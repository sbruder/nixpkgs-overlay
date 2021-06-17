{ lib, stdenv, fetchzip, makeWrapper, wrapGAppsHook, glib, jdk11 }:

stdenv.mkDerivation rec {
  pname = "VisiCut";
  version = "1.9-94-g8b1c96b7";

  src = fetchzip {
    url = "https://download.visicut.org/files/master/All/${pname}-${version}.zip";
    sha256 = "12xkysh66vcv17dffn9ybqk85lzxy4rqswxv4jwr0b1fwajfvd96";
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
