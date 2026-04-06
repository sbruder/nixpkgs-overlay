{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, click
}:

buildPythonPackage rec {
  pname = "dataclass_click";
  version = "1.0.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EOfeY43Z5orpq9UIb2HY3e5CsYc6cPX9n9IWeFavrBE=";
  };

  format = "pyproject";
  build-system = [ poetry-core ];

  propagatedBuildInputs = [
    click
  ];

  meta = with lib; {
    description = "Wrapper for pallets/click that uses dataclasses instead of kwargs";
    homepage = "https://github.com/couling/dataclass-click";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
