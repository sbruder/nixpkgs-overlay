# SPDX-FileCopyrightText: 2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ lib, runCommand, rustPlatform, kanidm, llvmPackages, freeradius, openssl, talloc }:
let
  freeradiusExtraHeaders = runCommand "freeradius-extra-headers" { } ''
    mkdir -p $out/freeradius
    # dlist.h does not seem to be packaged in the final build
    cp ${freeradius.src}/src/include/dlist.h $out/freeradius
  '';
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rlm_kanidm";

  inherit (kanidm) version src cargoHash;

  nativeBuildInputs = [
    # kanidm requires compiling with clang and linking with lld
    llvmPackages.bintools
    llvmPackages.clang
  ];

  buildInputs = [
    freeradius
    openssl
    talloc
  ];

  cargoBuildFlags = [ "--package" finalAttrs.pname ];
  buildFeatures = [ "extern-freeradius-module" ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;
  cargoCheckFeatures = finalAttrs.buildFeatures;

  doCheck = false; # currently broken

  postInstall = ''
    mv $out/lib/{lib,}rlm_kanidm.so
  '';

  env = rec {
    BINDGEN_EXTRA_CLANG_ARGS = CFLAGS;
    CFLAGS = "-I${freeradiusExtraHeaders}";
    LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  };

  meta = {
    description = "FreeRADIUS module for Kanidm authentication";
    homepage = "https://kanidm.github.io/kanidm/stable/integrations/radius.html";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ sbruder ];
    platforms = lib.platforms.linux;
  };
})
