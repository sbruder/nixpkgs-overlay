{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pythonRelaxDepsHook
, poetry-core
, aiohttp
, click
, cryptography
, ecpy
, platformdirs
, pycryptodome
, pyyaml
, requests
}:
let
  construct_2_8_8 = buildPythonPackage rec {
    pname = "construct";
    version = "2.8.8";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-G4S4FH9v0VvPZLc3w+isUQCBGtgMgwy0slRRQFEcQVc=";
    };

    pyproject = true;
    build-system = [ setuptools ];
  };
in
buildPythonPackage rec {
  pname = "pyplayready";
  version = "0.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qGts7jf6UC5J5baVagCG3md6//glB+00pFB+rI+lY68=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];
  pythonRelaxDeps = [
    "cryptography"
  ];

  pyproject = true;
  build-system = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    click
    construct_2_8_8
    cryptography
    ecpy
    platformdirs
    pycryptodome
    pyyaml
    requests
  ];

  meta = with lib; {
    description = "Python implementation of Microsoft's Playready DRM CDM (Content Decryption Module)";
    homepage = "https://git.gay/ready-dl/pyplayready";
    license = licenses.cc-by-nc-nd-40;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.linux;
  };
}
