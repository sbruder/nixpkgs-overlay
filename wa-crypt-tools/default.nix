{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, setuptools-scm
, javaobj-py3
, protobuf
, pycryptodomex
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "wa_crypt_tools";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-E/k2lKxlBxUDnfbeELHBi3sML3T+BQJ3zPHh4hGviJ4=";
  };

  format = "pyproject";
  build-system = [ setuptools setuptools-scm ];

  propagatedBuildInputs = [
    javaobj-py3
    protobuf
    pycryptodomex
  ];
  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];
  pythonRelaxDeps = [
    "protobuf"
  ];

  meta = with lib; {
    description = "Decryptor for WhatsApp’s databases";
    homepage = "https://github.com/ElDavoo/wa-crypt-tools";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
