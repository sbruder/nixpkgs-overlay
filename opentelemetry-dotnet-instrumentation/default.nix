# SPDX-FileCopyrightText: 2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ lib
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
, clang
, cmake
, gcc
, coreutils
, glibc
, gnugrep
}:

buildDotnetModule (finalAttrs: {
  pname = "opentelemetry-dotnet-instrumentation";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-hlsBcSXbAUiGXhTn2gBNTFbTT9a3uW/msWpDQiyemNA=";
  };

  postPatch = ''
    substituteInPlace src/OpenTelemetry.AutoInstrumentation.Native/CMakeLists.txt \
      --replace-fail 'message(FATAL_ERROR "GIT is required to build the project")' ""
  '';

  # for project in build/_build.csproj src/OpenTelemetry.AutoInstrumentation*/*.csproj; do dotnet restore "$project" --packages out; done && nuget-to-json out > deps.json
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;

  nativeBuildInputs = [
    clang
    cmake
    gcc
  ];

  dontDotnetConfigure = true;
  dontDotnetInstall = true;
  dontUseCmakeConfigure = true;

  env = {
    MINVERVERSIONOVERRIDE = "${finalAttrs.version}+0000000000000000000000000000000000000000";
  };

  buildPhase = ''
    runHook preBuild

    # some dependencies emit vulnerability warnings (nothing downstream can really fix), which are treated as errors
    dotnet run --project build/_build.csproj -p:TreatWarningsAsErrors=false

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r bin/tracer-home $out

    substituteInPlace $out/instrument.sh \
      --replace-fail "/bin/ls" '/bin/sh' \
      --replace-fail '$HOME/.otel-dotnet-auto' "$out"

    env -i PATH=${lib.makeBinPath [ coreutils glibc gnugrep ]} $out/instrument.sh env | grep -vE '^(PWD|SHLVL|PATH)=' | sort > $out/env

    runHook postInstall
  '';
})
