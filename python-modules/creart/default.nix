{ lib
, buildPythonPackage
, fetchPypi
, pdm-backend
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "creart";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Of6ndHbSbSvViRqjtfFsq1Vns3uFVIPjfwlLoAW/DR8=";
  };

  pyproject = true;
  build-system = [ pdm-backend ];

  propagatedBuildInputs = [
    importlib-metadata
  ];

  meta = with lib; {
    description = "a universal, extensible class instantiation helper";
    homepage = "https://github.com/GraiaProject/creart-graia";
    license = licenses.mit;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.linux;
  };
}
