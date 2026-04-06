{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, setuptools
}:
let
  construct_2_8_8 = buildPythonPackage rec {
    pname = "construct";
    version = "2.8.8";

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-G4S4FH9v0VvPZLc3w+isUQCBGtgMgwy0slRRQFEcQVc=";
    };

    pyproject = true;
    nativeBuildInputs = [ setuptools ];

    meta = {
      description = "Powerful declarative parser (and builder) for binary data";
      homepage = "https://construct.readthedocs.org/";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ sbruder ];
    };
  };
in
buildPythonPackage rec {
  pname = "pymp4";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vJ53cyqKFD00w4qoYqVBgHFiRpOOS/PgdYXRklK3e7U=";
  };

  format = "pyproject";
  build-system = [ poetry-core ];

  propagatedBuildInputs = [
    construct_2_8_8
  ];

  meta = with lib; {
    description = "A Python MP4 Parser and toolkit";
    homepage = "https://github.com/beardypig/pymp4";
    license = licenses.asl20;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
