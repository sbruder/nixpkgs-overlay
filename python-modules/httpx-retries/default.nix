{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, hatch-fancy-pypi-readme
, httpx
}:

buildPythonPackage rec {
  pname = "httpx_retries";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2Mjh4IUthL44N6ugvPeK64mkt325XozJiMjAWIMLMEQ=";
  };

  format = "pyproject";
  build-system = [ hatchling hatch-fancy-pypi-readme ];

  propagatedBuildInputs = [
    httpx
  ];

  meta = with lib; {
    description = "A retry layer for HTTPX";
    homepage = "https://will-ockmore.github.io/httpx-retries/";
    license = licenses.mit;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
