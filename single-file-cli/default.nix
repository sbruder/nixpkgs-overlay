{ lib, stdenv, fetchFromGitHub, fetchNpmDeps, makeWrapper, nodejs, npmHooks }:

stdenv.mkDerivation (finalAttrs: {
  pname = "single-file-cli";
  version = "2.0.83";

  src = fetchFromGitHub {
    owner = "gildas-lormeau";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-VCdBUGyRCEX1pRt0akrs6kTvgAPx+dskECZ2DK451g8=";
  };

  # does not get overridden automatically
  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-9s0mjg0Fh3Tf7izHZeY47F2NMHKmOTvuWUilhn7tboA=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    npmHooks.npmConfigHook
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/single-file-cli $out/bin
    cp -r *.js lib node_modules $out/share/single-file-cli

    makeWrapper ${nodejs}/bin/node $out/bin/single-file \
      --add-flags "$out/share/single-file-cli/single-file-node.js"

    runHook postInstall
  '';

  meta = with lib; {
    description = "CLI tool for saving a faithful copy of a complete web page in a single HTML file";
    homepage = "https://github.com/gildas-lormeau/single-file-cli";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.unix;
  };
})
