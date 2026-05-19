{ lib
, stdenv
, fetchFromGitHub
, gradle
, makeWrapper
, writableTmpDirAsHomeHook
, jdk17_headless
}:
let
  jdk = jdk17_headless;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "komf";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "Snd-R";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-S89YRPJEgX0WEyROj/BOe97n+SdtZyMdOwyajUDcsVg=";
  };

  nativeBuildInputs = [
    gradle
    makeWrapper
    writableTmpDirAsHomeHook # required for android dependencies to not fail
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
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
