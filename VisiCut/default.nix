{ lib, stdenv, fetchzip, makeWrapper, wrapGAppsHook, glib, jdk11 }:

stdenv.mkDerivation rec {
  pname = "VisiCut";
  version = "1.9-155-gb4085751";

  src = fetchzip {
    url = "https://download.visicut.org/files/master/All/${pname}-${version}.zip";
    sha256 = "sha256-vN537qrFmc3RG6e/ulm8AzVBNjmmmL/mmJUd5zhXpi4=";
  };

  nativeBuildInputs = [ makeWrapper wrapGAppsHook ];
  buildInputs = [ glib jdk11 ];

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    rm ${pname}.{exe,Linux,MacOS}
    mkdir -p $out/share
    cp -r . $out/share/${pname}

    runHook postInstall
  '';

  # Needs to be run in fixupPhase, since gappsWrapperArgs are not fully
  # populated in installPhase yet.
  postFixup = ''
    makeWrapper \
        ${jdk11}/bin/java \
        $out/bin/${pname} \
        --add-flags "-Xms256m -Xmx2048m -jar $out/share/${pname}/Visicut.jar" \
        "''${gappsWrapperArgs[@]}"
  '';

  meta = with lib; {
    description = "A userfriendly tool to prepare, save and send Jobs to Lasercutters";
    homepage = "https://visicut.org/";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
