{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, lib4sbom
, openpyxl
, packageurl-python
, reportlab
, requests
, rich
}:

buildPythonPackage rec {
  pname = "sbom2doc";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "anthonyharrison";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-P/HyeP1EerH8qCPSDU8dM8G2FVOO64buyYlDXCgKjsY=";
  };

  pyproject = true;
  build-system = [ setuptools ];

  propagatedBuildInputs = [
    lib4sbom
    openpyxl
    packageurl-python
    reportlab
    requests
    rich
  ];

  meta = with lib; {
    description = "Transform SBOM contents into a formatted document including markdown and PDF formats";
    homepage = "https://github.com/anthonyharrison/sbom2doc";
    license = licenses.asl20;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
