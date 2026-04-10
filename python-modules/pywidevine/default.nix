{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, pythonRelaxDepsHook
, click
, protobuf
, pycryptodome
, pymp4
, pyyaml
, requests
, unidecode
}:

buildPythonPackage rec {
  pname = "pywidevine";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Z0La9f15fFpIE+sTAO+zGB/83dDIxHjuKMfFNqoOUbI=";
  };

  format = "pyproject";
  build-system = [ poetry-core ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];
  propagatedBuildInputs = [
    click
    protobuf
    pycryptodome
    pymp4
    pyyaml
    requests
    unidecode
  ];
  pythonRelaxDeps = [
    "protobuf"
  ];

  meta = with lib; {
    description = "Python implementation of Google's Widevine DRM CDM (Content Decryption Module)";
    homepage = "https://github.com/devine-dl/pywidevine";
    license = licenses.gpl3;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
