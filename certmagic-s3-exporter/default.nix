# SPDX-FileCopyrightText: 2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ lib, buildGoModule, fetchFromForgejo }:

buildGoModule (finalAttrs: {
  pname = "certmagic-s3-exporter";
  version = "unstable-2026-08-21";

  src = fetchFromForgejo {
    domain = "git.sbruder.de";
    owner = "simon";
    repo = "certmagic-s3";
    rev = "8eab753e01ff5183ac704e478bc8aa627947a0e9";
    hash = "sha256-o01NUaZv9PRjx6lFTr4pYx/LTG1EMIx6WgQPErUjLpo=";
  };

  vendorHash = "sha256-/vCVtmbFdnXHeAUT75LjhyaeszTbl7ge5FUbBpqj/Vo=";

  subPackages = [ "cmd/exporter" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 "$GOPATH/bin/exporter" $out/bin/${finalAttrs.pname}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool for exporting certificates from a s3 bucket managed by certmagic-s3.";
    homepage = "https://git.sbruder.de/simon/certmagic-s3";
    license = licenses.asl20;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.linux;
    mainProgram = finalAttrs.pname;
  };
})
