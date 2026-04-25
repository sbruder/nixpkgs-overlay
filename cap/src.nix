{ lib, fetchFromGitHub, stdenv, bun, writableTmpDirAsHomeHook }:
let
  versions = builtins.fromJSON (builtins.readFile ./versions.json);
in
lib.mapAttrs
  (name: data:
  let
    pname = "cap-${name}";
    inherit (data) version;

    src = fetchFromGitHub {
      owner = "tiagozip";
      repo = "cap";
      rev = "${name}@${data.version}";
      hash = data.srcHash;
    };

    sourceRoot = "${src.name}/${name}";
  in
  {
    inherit pname version src sourceRoot;

    meta = with lib; {
      description = "The privacy-first, self-hosted CAPTCHA for the modern web (${name} component)";
      homepage = "http://capjs.js.org/";
      license = licenses.asl20;
      maintainers = with lib.maintainers; [ sbruder ];
      platforms = lib.platforms.linux;
    };
  } // (lib.optionalAttrs (data ? "nodeModulesHash") {
    node_modules = stdenv.mkDerivation {
      pname = "${name}-node_modules";
      inherit src sourceRoot version;

      nativeBuildInputs = [
        bun
        writableTmpDirAsHomeHook
      ];

      dontConfigure = true;

      buildPhase = ''
        runHook preBuild

        export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
        bun install --no-progress --frozen-lockfile --no-cache

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir $out
        cp -r node_modules $out

        runHook postInstall
      '';

      dontFixup = true;

      outputHash = data.nodeModulesHash;
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    };
  }) // (lib.optionalAttrs (data ? "cargoHash") {
    inherit (data) cargoHash;
  }))
  versions
