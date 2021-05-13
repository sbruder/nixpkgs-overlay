{ lib
, buildPythonPackage
, fetchPypi
, click
, deezer-py
, eventlet
, mutagen
, pycryptodomex
, requests
, spotipy
}:

buildPythonPackage rec {
  pname = "deemix";
  version = "2.0.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q5nzx540a2xk2gw225yjrjn2py4b7naim6kk7li97gwarp9r0h9";
  };

  propagatedBuildInputs = [
    click
    deezer-py
    eventlet
    mutagen
    pycryptodomex
    requests
    spotipy
  ];

  doCheck = false; # error: protocol not found

  meta = with lib; {
    description = "A python library that lets you download millions of songs, soundtracks, albums in high-quality mp3 and FLAC";
    homepage = "https://download.deemix.app/";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
