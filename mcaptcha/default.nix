{ lib
, fetchFromGitHub
, stdenv
, fetchYarnDeps
, nodejs_24
, yarnBuildHook
, yarnConfigHook
, rustPlatform
, pkg-config
, openssl
}:
let
  pname = "mCaptcha";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2900GArHM75IHMfN+bWFbeczKrZK/fG50ImUtiLMft4=";
  };

  frontend = stdenv.mkDerivation {
    pname = "${pname}-frontend";
    inherit version src;

    postPatch = ''
      patchShebangs scripts
    '';

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = src + "/yarn.lock";
      hash = "sha256-3HttWhqK1EWYnVR+dkp495jNRwib9qq7WJZzQ+Wl1DY=";
    };

    nativeBuildInputs = [
      nodejs_24
      yarnConfigHook
    ];

    buildPhase = ''
      runHook preBuild

      # adapated from Makefile
      yarn build
      yarn run sass -s \
        compressed templates/main.scss \
        ./static/cache/bundle/css/main.css
      yarn run sass -s \
        compressed templates/mobile.scss \
        ./static/cache/bundle/css/mobile.css
      yarn run sass -s \
        compressed templates/widget/main.scss \
        ./static/cache/bundle/css/widget.css
      ./scripts/librejs.sh
      ./scripts/cachebust.sh

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp -r static/cache/bundle $out

      runHook postInstall
    '';
  };

  openapi = stdenv.mkDerivation {
    pname = "${pname}-openapi";
    inherit version src;

    sourceRoot = "${src.name}/docs/openapi";

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = src + "/docs/openapi/yarn.lock";
      hash = "sha256-vsgc/y/3aQOwoWM/WWf3oYNX0RucaXvJdgigb56j+w8=";
    };

    nativeBuildInputs = [
      nodejs_24
      yarnBuildHook
      yarnConfigHook
    ];

    installPhase = ''
      runHook preInstall

      cp -r dist $out

      runHook postInstall
    '';
  };

  cache-bust = rustPlatform.buildRustPackage {
    pname = "${pname}-cache-bust";
    inherit version src;

    sourceRoot = "${src.name}/utils/cache-bust";

    cargoHash = "sha256-e18PJFmvUf3droMT26Q0ZCgVFCwG9y/efPFO0SlILW0=";
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "actix-auth-middleware-0.2.0" = "sha256-sLd2Fsa02bXE+CTzTcByTF2PAnzn5YEYGekCmw+AG4E=";
      "actix-web-codegen-4.0.0" = "sha256-2MKgeCa9C5WL0TtvQSTvz2YMBBgzn7tnkFL7c7KJFSs=";
      "argon2-creds-0.2.3" = "sha256-qykKQBAt1U+fWRfQi9l9lksH9b8AY15GJpwdPQXaIS0=";
    };
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  # fake (but constant) data
  GIT_HASH = "0000000000000000000000000000000000000000";
  COMPILED_DATE = "19700101";

  postPatch = ''
    # upstream is outdated and does not build anymore, this is obtained by running `cargo update` once
    cp ${./Cargo.lock} Cargo.lock

    # use nixpkgs openssl
    substituteInPlace Cargo.toml \
      --replace-fail ', features = ["vendored"]' ""

    # impurities (git hash, current date)
    echo "fn main() { }" > build.rs
  '';

  preConfigure = ''
    ln -s ${frontend} static/cache/bundle
    ln -s ${openapi} docs/openapi/dist
  '';

  preBuild = ''
    # needs to be run from this directory
    pushd utils/cache-bust
    ${cache-bust}/bin/cache-bust
    popd
  '';

  doCheck = false; # requires running postgres/mariadb

  postInstall = ''
    install -Dm444 config/default.toml $out/share/mcaptcha/config.toml
  '';

  meta = {
    description = "A no-nonsense CAPTCHA system with seamless UX";
    homepage = "https://mcaptcha.org/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ sbruder ];
    platforms = lib.platforms.linux;
  };
}
