{ callPackage
, stdenv
, makeWrapper
, bun
, dbip-asn-lite
, dbip-country-lite
, cap-wasm
, cap-widget
}:
let
  src = (callPackage ./src.nix { }).standalone;
in
stdenv.mkDerivation {
  inherit (src)
    pname
    version
    src
    sourceRoot
    meta;

  patches = [
    ./0001-Load-assets-from-local-directory.patch
    ./0002-Show-local-asset-in-integration-tab.patch
    ./0004-Show-widget-import-as-module-in-dashboard.patch
    ./0005-Resolve-IPDB-conflict-on-read-only-filesystem.patch
  ];
  patchFlags = [ "-p2" ];

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/cap/standalone

    # bundling with bun does not work (instrumentation times out)
    cp -r ${src.node_modules}/node_modules package.json public src $out/share/cap/standalone

    mkdir -p $out/share/cap/standalone/assets
    cp ${cap-wasm}/share/cap/wasm/cap_wasm{.js,_bg.wasm} $out/share/cap/standalone/assets
    cp ${cap-widget}/share/cap/widget/cap.min.js $out/share/cap/standalone/assets/widget.js
    cp ${cap-widget}/share/cap/widget/cap-floating.min.js $out/share/cap/standalone/assets/floating.js

    mkdir -p $out/share/cap/standalone/data
    ln -s ${dbip-asn-lite}/share/dbip/dbip-asn-lite.mmdb $out/share/cap/standalone/data/dbip-asn.mmdb
    ln -s ${dbip-country-lite}/share/dbip/dbip-country-lite.mmdb $out/share/cap/standalone/data/dbip-country.mmdb

    makeWrapper ${bun}/bin/bun $out/bin/cap \
      --add-flags "run $out/share/cap/standalone/src/index.js" \
      --chdir "$out/share/cap/standalone"

    runHook postInstall
  '';
}
