# SPDX-FileCopyrightText: 2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ lib
, buildNpmPackage
, stdenv
, fetchFromGitHub
, fetchNpmDeps
, nodejs_22
, npmHooks
, ffmpeg
, nunicode
, routerBasePath ? ""
}:
let
  nodejs = nodejs_22;

  pname = "audiobookshelf";
  version = "2.36.1";

  src = fetchFromGitHub {
    owner = "advplyr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HBaTTfZEbhR2n/XafScZB/gX29erTQHZ+IdErwhA11A=";
  };

  client = stdenv.mkDerivation (finalAttrs: {
    pname = "${pname}-client";
    inherit version src;

    sourceRoot = "source/client";

    npmDeps = fetchNpmDeps {
      inherit src;
      inherit (finalAttrs) sourceRoot;
      hash = "sha256-g3Y/4UU2YH/CeU8Z/NNkLP0OTeBM+4/rQfL406uVdio=";
    };

    nativeBuildInputs = [
      nodejs
      npmHooks.npmConfigHook
      npmHooks.npmBuildHook
    ];

    npmBuildScript = "generate";

    installPhase = ''
      runHook preInstall
      mv dist $out
      runHook postInstall
    '';

    env = {
      CYPRESS_INSTALL_BINARY = "0";
      ROUTER_BASE_PATH = routerBasePath;
    };
  });
in
buildNpmPackage {
  inherit pname version src nodejs;

  npmDepsHash = "sha256-kp0LbSKaHTBppeyfLAFrGYnSWS3V2trO5yaZWoxVPo8=";

  dontNpmBuild = true;
  npmInstallFlags = [ "--only=production" ];

  makeWrapperArgs = lib.mapAttrsToList (k: v: "--set ${k} ${lib.escapeShellArg v}") {
    NODE_ENV = "production";
    SOURCE = "sbruder-nixpkgs-overlay";
    SKIP_BINARIES_CHECK = "1";
    FFMPEG_PATH = "${ffmpeg}/bin/ffmpeg";
    FFPROBE_PATH = "${ffmpeg}/bin/ffprobe";
    NUSQLITE3_PATH = "${nunicode.sqlite}/lib/libnusqlite3.so";
    ROUTER_BASE_PATH = routerBasePath;
  };

  postInstall = ''
    ln -s ${client} $out/lib/node_modules/audiobookshelf/client/dist
  '';

  meta = {
    description = "Self-hosted audiobook and podcast server";
    homepage = "https://audiobookshelf.org/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sbruder ];
    mainProgram = pname;
    sourceProvenance = lib.sourceTypes.fromSource;
  };
}
