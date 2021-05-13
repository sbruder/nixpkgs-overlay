{ lib, stdenv, fetchzip, makeWrapper, jdk11, gsettings-desktop-schemas, gtk3 }:

stdenv.mkDerivation rec {
  pname = "VisiCut";
  version = "1.9-94-g8b1c96b7";

  src = fetchzip {
    url = "https://download.visicut.org/files/master/All/${pname}-${version}.zip";
    sha256 = "12xkysh66vcv17dffn9ybqk85lzxy4rqswxv4jwr0b1fwajfvd96";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk11 ];

  # FIXME: Use proper way of wrapping a gnome application
  installPhase = ''
    rm ${pname}.{exe,Linux,MacOS}
    mkdir -p $out/share
    cp -r . $out/share/${pname}
    makeWrapper \
        ${jdk11}/bin/java \
        $out/bin/${pname} \
        --add-flags "-Xms256m -Xmx2048m -jar $out/share/${pname}/Visicut.jar" \
        --set "XDG_DATA_DIRS" "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS"
  '';

  meta = with lib; {
    description = "A userfriendly tool to prepare, save and send Jobs to Lasercutters";
    homepage = "https://visicut.org/";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
