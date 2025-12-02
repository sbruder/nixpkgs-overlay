{ lib, stdenv, fetchFromGitHub, nodejs, pnpm_10 }:

stdenv.mkDerivation (finalAttrs: {
  pname = "feishin";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "jeffvli";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-sRP89xgCl49WZ7A6KaQd/vJTIDvAfZuhRbL3mcBBnIg=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10.configHook
  ];

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-qT1eyPQcP4XJYzgTM5vmpt1mC2309IMyMKE/Cn5Eihw=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm build:web

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r out/web $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "A modern self-hosted music player";
    homepage = "https://github.com/jeffvli/feishin";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.linux;
  };
})
