{ callPackage
, stdenv
, bun
}:
let
  src = (callPackage ./src.nix { }).widget;
in
stdenv.mkDerivation {
  inherit (src)
    pname
    version
    src
    sourceRoot
    meta;

  patches = [
    ./0003-Use-local-wasm-URL-in-widget.patch
  ];
  patchFlags = [ "-p2" ];

  postPatch = ''
    substituteInPlace build.js \
      --replace-fail 'console.time("test");' 'process.exit(0)'

    # remove pre-built files
    rm src/*.{js,ts,css}
  '';

  nativeBuildInputs = [
    bun
  ];

  configurePhase = ''
    runHook preConfigure
    cp -r ${src.node_modules}/node_modules .
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    bun run build.js
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/cap/widget
    cp src/*.{js,css} $out/share/cap/widget
    runHook postInstall
  '';
}
