# SPDX-FileCopyrightText: 2023, 2025 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ lib, stdenv, fetchFromGitHub, nodejs, pnpmConfigHook, pnpm_11, fetchPnpmDeps }:

stdenv.mkDerivation (finalAttrs: {
  pname = "aonsoku";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "victoralvesf";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-zHYr50FBV7sSdNz6j07SdlMbVaXKj1SnJHmtjmsnBdY=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_11
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11;
    fetcherVersion = 3;
    hash = "sha256-Vu38fYEqdnNwj8chKh52iLUVDrM+dTTnepiNgvp3dAA=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "A modern client for Navidrome/Subsonic servers built with React";
    homepage = "https://github.com/victoralvesf/aonsoku";
    license = licenses.mit;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.linux;
  };
})
