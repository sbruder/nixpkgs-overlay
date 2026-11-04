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

  # targets .NET Core 8, 9 and 10 (TFM) and needs the dependencies in the exact version they ship with
  buildInputs = lib.concatMap (tfm: tfm.packages) (with dotnetCorePackages; [
    sdk_8_0
    sdk_9_0
    # sdk_10_0 implicit via dotnet-sdk
  ]);

  postPatch = ''
    substituteInPlace src/OpenTelemetry.AutoInstrumentation.Native/CMakeLists.txt \
      --replace-fail 'message(FATAL_ERROR "GIT is required to build the project")' ""
  '';

  projectFile = [
    "build/_build.csproj"
    "src/OpenTelemetry.AutoInstrumentation.AspNetCoreBootstrapper/OpenTelemetry.AutoInstrumentation.AspNetCoreBootstrapper.csproj"
    "src/OpenTelemetry.AutoInstrumentation.Assemblies/OpenTelemetry.AutoInstrumentation.Assemblies.csproj"
    "src/OpenTelemetry.AutoInstrumentation.BuildTasks/OpenTelemetry.AutoInstrumentation.BuildTasks.csproj"
    "src/OpenTelemetry.AutoInstrumentation.Loader/OpenTelemetry.AutoInstrumentation.Loader.csproj"
    "src/OpenTelemetry.AutoInstrumentation.PluginApi/OpenTelemetry.AutoInstrumentation.PluginApi.csproj"
    "src/OpenTelemetry.AutoInstrumentation.StartupHook/OpenTelemetry.AutoInstrumentation.StartupHook.csproj"
    "src/OpenTelemetry.AutoInstrumentation/OpenTelemetry.AutoInstrumentation.csproj"
  ];
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;

  nativeBuildInputs = [
    clang
    cmake
    gcc
  ];

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

  meta = with lib; {
    description = "OpenTelemetry .NET Automatic Instrumentation";
    homepage = "https://opentelemetry.io/docs/zero-code/dotnet/";
    license = licenses.asl20;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
