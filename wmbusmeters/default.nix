{ lib, stdenv, fetchFromGitHub, librtlsdr, libxml2 }:

stdenv.mkDerivation rec {
  pname = "wmbusmeters";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    hash = "sha256-Y/xHw++llHw3iIImXllJg7QqU0Ngj0MLJyyqE1dBNjA=";
  };

  buildInputs = [
    librtlsdr
    libxml2
  ];

  NIX_CFLAGS_COMPILE = "-I${libxml2.dev}/include/libxml2";

  makeFlags = [
    "DESTDIR=$(out)"
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    patchShebangs scripts install.sh
  '';

  postInstall = ''
    mkdir -p $out/{bin,share}
    mv $out/usr/{bin/wmbusmeters,sbin/wmbusmetersd} $out/bin
    mv $out/{usr/,}share/man
    rmdir $out/usr/{bin,sbin,share}
    rmdir $out/usr

    rm -r $out/var
  '';

  meta = with lib; {
    description = "Read the wired or wireless mbus protocol to acquire utility meter readings";
    homepage = "https://wmbusmeters.org/";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.unix;
  };
}
