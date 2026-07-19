# SPDX-FileCopyrightText: 2025-2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ lib, stdenv, fetchFromGitHub, nodejs, pnpmConfigHook, pnpm_11, fetchPnpmDeps }:

stdenv.mkDerivation (finalAttrs: {
  pname = "feishin";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "jeffvli";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-Lu1vxZg8n+3zkvvJxyD/yw6RIfv1DHCuMdlSPxSc4cE=";
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
    hash = "sha256-Xjf+zRu1ZMf5zlJJP+TSYkVKxthQG31VGX5+jw8QOIY=";
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
