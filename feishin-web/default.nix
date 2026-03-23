{ lib, stdenv, fetchFromGitHub, nodejs, pnpm_10 }:

stdenv.mkDerivation (finalAttrs: {
  pname = "feishin";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "jeffvli";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-LcSe7aEtTDs4JIk50zI0IFgN4ZCSJ6NClfk02uO2Sg8=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10.configHook
  ];

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-cGIdcMcBIoSbtaN4ZcS/hM0fVsW08fqac4LIlpj/nb4=";
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
