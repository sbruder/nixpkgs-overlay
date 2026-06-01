# SPDX-FileCopyrightText: 2023, 2025 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ lib, stdenv, fetchFromGitHub, nodejs, pnpmConfigHook, pnpm_10, fetchPnpmDeps }:

stdenv.mkDerivation (finalAttrs: {
  pname = "aonsoku";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "victoralvesf";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-Rbte0qYcZQ70E6ib8rj0YsNP5SMNO8eC3MEvWcT7N08=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_10
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-3ymQef73DqXb4UjlEyhrtVxFM+4EIZGUK6bkADwOekk=";
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
