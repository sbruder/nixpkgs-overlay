# SPDX-FileCopyrightText: 2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ lib, buildGoModule, fetchFromGitHub, llvmPackages, makeWrapper, bash }:
let
  bpf2go = buildGoModule (finalAttrs: {
    pname = "bpf2go";
    # keep in sync with opentelemetry-ebpf-instrumentation/internal/tools/go.mod (github.com/cilium/ebpf)
    version = "0.22.0";

    src = fetchFromGitHub {
      owner = "cilium";
      repo = "ebpf";
      rev = "v${finalAttrs.version}";
      hash = "sha256-anKE+OjS4h5S/y6eXUgoOmKcdLJxoqHCqUKqAna5hsM=";
    };

    vendorHash = "sha256-zR+lUcACRr061TxwFVEjsLtFAmKyrlgvPfwaJ8HMIoo=";

    nativeBuildInputs = [
      llvmPackages.bintools-unwrapped
      llvmPackages.clang-unwrapped
      makeWrapper
    ];

    subPackages = [ "cmd/bpf2go" ];

    doCheck = false; # require downloading additional go modules

    postInstall = ''
      wrapProgram $out/bin/bpf2go \
        --prefix PATH : ${lib.makeBinPath (with llvmPackages; [ bintools-unwrapped clang-unwrapped ])}
    '';

    meta = with lib; {
      description = "Compile a C source file into eBPF bytecode and then emit a Go file containing the eBPF";
      homepage = "https://ebpf-go.dev/";
      license = licenses.mit;
      maintainers = with maintainers; [ sbruder ];
      platforms = platforms.linux;
      mainProgram = "bpf2go";
      sourceProvenance = with lib.sourceTypes; [ fromSource ];
    };
  });
in
buildGoModule (finalAttrs: {
  pname = "opentelemetry-ebpf-instrumentation";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-D4bj7UOEKqJaNGVcDpqH8LLuJQRTzBArc760t0gwegk=";
  };

  vendorHash = "sha256-znHR3RYcOzVVOwa5LrA8N1Kxj/P6DrsQH6hVONTTxwM=";

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "/usr/bin/env bash" "${lib.getExe bash}"

    mkdir .tools
    ln -s ${lib.getExe bpf2go} .tools/bpf2go
  '';

  preBuild = ''
    # go eBPF bindings
    make generate/all
  '';

  overrideModAttrs = _finalAttrs: _prevAttrs: {
    # do not run preBuild when vendoring dependencies
    preBuild = "";
  };

  ldflags = [
    "-X go.opentelemetry.io/obi/pkg/buildinfo.Version=${finalAttrs.version}"
    "-X go.opentelemetry.io/obi/pkg/buildinfo.Revision=unset"
  ];

  subPackages = [ "cmd/obi" ];

  meta = with lib; {
    description = "Zero-code OpenTelemetry instrumentation powered by eBPF";
    homepage = "https://opentelemetry.io/docs/zero-code/obi/";
    license = licenses.asl20;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.linux;
    mainProgram = "obi";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
