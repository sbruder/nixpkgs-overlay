{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, emoji
, pydbus
, pygobject3
, strenum
, unidecode
}:

buildPythonPackage rec {
  pname = "mpris_server";
  version = "0.9.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-T0ZeDQiYIAhKR8aw3iv3rtwzc+R0PTQuIh6+Hi4rIHQ=";
  };

  pyproject = true;
  build-system = [ setuptools ];

  propagatedBuildInputs = [
    emoji
    pydbus
    pygobject3
    strenum
    unidecode
  ];

  meta = with lib; {
    description = "Publish a MediaPlayer2 MPRIS device to D-Bus";
    homepage = "https://github.com/alexdelorenzo/mpris_server";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
