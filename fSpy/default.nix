{ lib, appimageTools, fetchurl, gsettings-desktop-schemas, gtk3 }:
let
  pname = "fSpy";
  version = "1.0.3";
in
appimageTools.wrapType2 {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/stuffmatic/${pname}/releases/download/v${version}/${lib.toLower pname}-${version}-x86_64.AppImage";
    sha256 = "0w0ps15xx6nyn0gy4xwhlmgc37ddmfggrm9rjbclq4kf9i4arsig";
  };

  profile = ''
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  meta = with lib; {
    description = "A cross platform app for quick and easy still image camera matching";
    homepage = "https://fspy.io";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sbruder ];
    platforms = [ "x86_64-linux" ];
  };
}
