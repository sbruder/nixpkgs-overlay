# SPDX-FileCopyrightText: 2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0


{ lib, stdenv, fetchurl }:
let
  agentFilePath = "share/opentelemetry-javaagent.jar";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "opentelemetry-javaagent";
  version = "2.32.0";

  src = fetchurl {
    url = "https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v${finalAttrs.version}/opentelemetry-javaagent.jar";
    sha256 = "sha256-94frbH89GOaaQx4QihUnjSXuN/g9aLZ49iHgY/OYj4I=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm444 $src $out/${agentFilePath}

    runHook postInstall
  '';

  passthru = {
    agentFile = "${finalAttrs.finalPackage}/${agentFilePath}";
  };

  meta = with lib; {
    description = "OpenTelemetry Zero-code instrumentation for any Java 8+ application";
    homepage = "https://opentelemetry.io/docs/zero-code/java/agent/";
    license = licenses.asl20;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
