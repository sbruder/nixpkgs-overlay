# SPDX-FileCopyrightText: 2025-2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ lib, stdenv, fetchFromGitHub, nodejs, pnpmConfigHook, pnpm_10, fetchPnpmDeps }:

stdenv.mkDerivation (finalAttrs: {
  pname = "feishin";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "jeffvli";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-2MpuKVrG60PQwMZNHfprzwPbjcHbIRekpnCShA3TR5g=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_10
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-zNOGJ24G0xcgsGK4DmbBm7d1PHTp7IJS+RTALGRtfDg=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm build:web

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r out/web $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "A modern self-hosted music player";
    homepage = "https://github.com/jeffvli/feishin";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.linux;
  };
})
