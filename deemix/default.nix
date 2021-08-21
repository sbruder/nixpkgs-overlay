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
  version = "3.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-cSLjbowG98pbEzGB17Rkhli90xeOyzOcEglXb5SeNJE=";
  };

  propagatedBuildInputs = [
    click
    deezer-py
    mutagen
    pycryptodomex
    requests
    spotipy
  ];

  doCheck = false; # error: protocol not found

  meta = with lib; {
    description = "A python library that lets you download millions of songs, soundtracks, albums in high-quality mp3 and FLAC";
    homepage = "https://deemix.app/";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
