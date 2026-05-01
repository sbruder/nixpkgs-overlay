{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mCaptcha-cache";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "mCaptcha";
    repo = "cache";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Uryk8TSrI/Hkn3qBgp4fNSYNaG+4ba9Zcve3ht7q7yw=";
  };

  cargoHash = "sha256-uQ/Bvee21iZxot6QULaW7kRiepD5Xlg6ofFRN+bP9AM=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  doCheck = false;

  meta = {
    description = "Redis module that implements mCaptcha cache and counter";
    homepage = "https://github.com/mCaptcha/cache";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ sbruder ];
    platforms = lib.platforms.linux;
  };
})
