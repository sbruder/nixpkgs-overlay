# SPDX-FileCopyrightText: 2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ lib
, stdenv
, fetchFromGitHub
, gradle_9
, makeWrapper
, writableTmpDirAsHomeHook
, jdk17_headless
}:
let
  jdk = jdk17_headless;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "komf";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "Snd-R";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-W9DK8iT/gJu8j1Q7imxRggKLWQBSIzFA4rgyt9CN1To=";
  };

  nativeBuildInputs = [
    gradle_9
    makeWrapper
    writableTmpDirAsHomeHook # required for android dependencies to not fail
  ];

  mitmCache = gradle_9.fetchDeps {
    inherit (finalAttrs) pname;
    # merged so it builds under both 26.05 and unstable
    # jq --indent 1 -s '.[0] * .[1]' deps.json deps-stable.json > deps-merged.json
    data = ./deps.json;
  };

  gradleFlags = [ "-Dorg.gradle.java.home=${jdk}" ];

  gradleBuildTask = ":komf-app:shadowjar";
  gradleUpdateTask = finalAttrs.gradleBuildTask; # required as nixDownloadDeps fails for (optional) android dependencies

  installPhase = ''
    runHook preInstall
    install -Dm444 komf-app/build/libs/komf-app-*-all.jar $out/share/komf/komf-all.jar
    makeWrapper ${jdk}/bin/java $out/bin/komf --add-flags "-jar $out/share/komf/komf-all.jar"
    runHook postInstall
  '';

  meta = {
    description = "Komga and Kavita metadata fetcher";
    homepage = "https://github.com/Snd-R/komf";
    license = lib.licenses.mit;
    platforms = jdk.meta.platforms;
    maintainers = with lib.maintainers; [ sbruder ];
    mainProgram = "komf";
    sourceProvenance = with lib.sourceTypes; [ fromSource binaryBytecode ];
  };
})
