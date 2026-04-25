{ rustPlatform
, callPackage
, binaryen
, lld
, wasm-bindgen-cli_0_2_100
, wasm-pack
, writableTmpDirAsHomeHook
}:
let
  src = (callPackage ./src.nix { }).wasm;
in
rustPlatform.buildRustPackage {
  inherit (src)
    pname
    version
    src
    cargoHash
    meta;

  sourceRoot = "${src.sourceRoot}/src/rust";

  nativeBuildInputs = [
    binaryen
    lld
    wasm-bindgen-cli_0_2_100
    wasm-pack
    writableTmpDirAsHomeHook
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/share/cap/wasm

    wasm-pack build --target web --out-dir $out/share/cap/wasm --out-name cap_wasm

    runHook postBuild
  '';

  dontCargoInstall = true;
}
