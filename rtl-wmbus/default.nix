{ lib, stdenv, fetchFromGitHub, librtlsdr }:

stdenv.mkDerivation rec {
  pname = "rtl-wmbus";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "weetmuts";
    repo = pname;
    rev = version;
    hash = "sha256-hqlvL0EhmxZ5NxyCxOB1a7S9mEnWrkUrrh7EPdXSN7k=";
  };

  buildInputs = [
    librtlsdr
  ];

  makeFlags = [
    "DESTDIR=$(out)"
    "release"
  ];

  postInstall = ''
    mkdir -p $out/bin
    mv $out/usr/bin/rtl_wmbus $out/bin
    rmdir $out/usr/bin
    rmdir $out/usr
  '';

  meta = with lib; {
    description = "Software defined receiver for wireless M-Bus with RTL-SDR";
    homepage = "https://github.com/weetmuts/rtl-wmbus";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.unix;
  };
}
