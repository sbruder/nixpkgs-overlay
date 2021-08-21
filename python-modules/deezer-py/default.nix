{ lib
, buildPythonPackage
, fetchPypi
, requests
, eventlet
}:

buildPythonPackage rec {
  pname = "deezer-py";
  version = "1.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FdLSJFALeGcecLAHk9khJTKlMd3Mec/w/PGQOHqxYMQ=";
  };

  propagatedBuildInputs = [
    requests
  ];

  doCheck = false; # OSError: protocol not found

  meta = with lib; {
    description = "A python wrapper for all Deezer’s APIs";
    homepage = "https://gitlab.com/RemixDev/deezer-py";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
