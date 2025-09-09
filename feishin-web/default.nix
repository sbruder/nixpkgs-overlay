{ lib, stdenv, fetchFromGitHub, nodejs, pnpm_10 }:

stdenv.mkDerivation (finalAttrs: {
  pname = "feishin";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "jeffvli";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-+pBN23IKdUVBlfm6Sydg78RYFSfzwX/Sc86FWjB0Nzg=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10.configHook
  ];

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-toVWebJoh2PB4mWTulEs1iVrzEtnWtbBd6Ga2uTxU8k=";
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
