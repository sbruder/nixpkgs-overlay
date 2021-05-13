{ lib
, buildPythonPackage
, fetchPypi
, requests
, eventlet
}:

buildPythonPackage rec {
  pname = "deezer-py";
  version = "0.0.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0sg4r8f11b11ygb5ra7gwsnxjhkzwhaniii0v69kqcypkxncc3ys";
  };

  propagatedBuildInputs = [
    requests
    eventlet
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
