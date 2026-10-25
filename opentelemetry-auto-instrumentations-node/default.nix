# SPDX-FileCopyrightText: 2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ lib, stdenv, importNpmLock, nodejs }:
let
in
stdenv.mkDerivation (finalAttrs: {
  pname = "opentelemetry-auto-instrumentations-node";
  version = (builtins.fromJSON (builtins.readFile ./package-lock.json)).packages."node_modules/@opentelemetry/auto-instrumentations-node".version;

  src = importNpmLock.buildNodeModules {
    npmRoot = ./.;
    inherit nodejs;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    cp -r $src $out
    runHook postInstall
  '';

  passthru.activateEnv = {
    NODE_PATH = "${finalAttrs.finalPackage}/node_modules";
    NODE_OPTIONS = "--require @opentelemetry/auto-instrumentations-node/register";
  };

  meta = with lib; {
    description = "OpenTelemetry JavaScript (Node.js) Automatic Instrumentation";
    homepage = "https://opentelemetry.io/docs/zero-code/js/";
    license = licenses.asl20;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
