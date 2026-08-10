# SPDX-FileCopyrightText: 2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ lib
, stdenv
, fetchFromGitHub
, fetchNpmDeps
, nodejs_22
, nodejs_24
, npmHooks
, dart-sass
, gradle_9
, makeWrapper
, jdk25_headless
, libwebp
}:
let
  jdk = jdk25_headless;

  pname = "komga";
  version = "1.26.1";

  src = fetchFromGitHub {
    owner = "gotson";
    repo = pname;
    rev = version;
    leaveDotGit = true;
    branchName = "master"; # displayed in UI, so it should not be `fetchgit`
    hash = "sha256-Q4o8RCvio0ELZwLMW45aSRNhuOaFcfTQBTjwl8g9Pvo=";
  };

  webui = stdenv.mkDerivation (finalAttrs: {
    pname = "${pname}-webui";
    inherit version src;

    sourceRoot = "source/komga-webui";

    npmDeps = fetchNpmDeps {
      inherit src;
      inherit (finalAttrs) sourceRoot;
      hash = "sha256-B9GS4yY2Abz7WgiaPlHjUNUF1zER5RjHmTA4aizAG9k=";
    };

    nativeBuildInputs = [
      nodejs_22
      npmHooks.npmConfigHook
      npmHooks.npmBuildHook
    ];

    npmBuildScript = "build";

    makeCacheWritable = true;

    installPhase = ''
      runHook preInstall
      mv dist $out
      runHook postInstall
    '';
  });

  next-ui = stdenv.mkDerivation (finalAttrs: {
    pname = "${pname}-next-ui";
    inherit version src;

    sourceRoot = "source/next-ui";

    npmDeps = fetchNpmDeps {
      inherit src;
      inherit (finalAttrs) sourceRoot;
      hash = "sha256-2iEz+VFwqc///wcpo3eOxqUcefwrWk+z9tINTyyn3Qk=";
    };

    nativeBuildInputs = [
      nodejs_24
      npmHooks.npmConfigHook
      npmHooks.npmBuildHook
    ];

    postConfigure = ''
      echo 'export const compilerCommand = ["${lib.getExe dart-sass}"]' > node_modules/sass-embedded/dist/lib/src/compiler-path.js
    '';

    npmBuildScript = "build:with-i18n";

    installPhase = ''
      runHook preInstall
      mv dist $out
      runHook postInstall
    '';
  });
in
stdenv.mkDerivation {
  inherit src pname version;

  nativeBuildInputs = [
    gradle_9
    makeWrapper
  ];

  mitmCache = gradle_9.fetchDeps {
    inherit pname;
    # merged so it builds under both 26.05 and unstable
    # jq --indent 1 -s '.[0] * .[1]' deps.json deps-stable.json > deps-merged.json
    data = ./deps.json;
  };

  postPatch = ''
    cp -r --no-preserve=mode ${webui} komga-webui/dist
    cp -r --no-preserve=mode ${next-ui} next-ui/dist
  '';

  gradleFlags = [ "-Dorg.gradle.java.home=${jdk}" ];

  gradleBuildTask = "webuiCopyIndex :komga:nextuiCopyIndex :komga:bootJar";

  installPhase = ''
    runHook preInstall

    install -Dm444 komga/build/libs/${pname}-${version}.jar $out/share/${pname}/${pname}-${version}.jar
    makeWrapper ${jdk}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/${pname}/${pname}-${version}.jar" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libwebp ]}

    runHook postInstall
  '';

  meta = {
    description = "Media server for comics/mangas/BDs/magazines/eBooks with API, OPDS, Kobo Sync and KOReader Sync support";
    homepage = "https://komga.org";
    license = lib.licenses.mit;
    platforms = jdk.meta.platforms;
    maintainers = with lib.maintainers; [ sbruder ];
    mainProgram = pname;
    sourceProvenance = with lib.sourceTypes; [ fromSource binaryBytecode ];
  };
}
