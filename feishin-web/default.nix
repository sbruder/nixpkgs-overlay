{ lib, stdenv, fetchFromGitHub, nodejs, pnpm_10 }:

stdenv.mkDerivation (finalAttrs: {
  pname = "feishin";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "jeffvli";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-TSjgjNHhPSZ4k7zZTH5e3FCkl6d7B/2w2WCt0S5OW0g=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10.configHook
  ];

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-9Ecbvr8yMX0fs7wf5UjVRq6kx/PjAYK1hwKHKf9kgys=";
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
