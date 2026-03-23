{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, lib4package
, lib4sbom
, packageurl-python
, python-dateutil
, pytz
, requests
, rich
}:

buildPythonPackage rec {
  pname = "sbomaudit";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "anthonyharrison";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-uZlQwMiaUGKGogd6TDI0ticBxqOa5Nw5gjvpahRdSAU=";
  };

  pyproject = true;
  build-system = [ setuptools ];

  propagatedBuildInputs = [
    lib4package
    lib4sbom
    packageurl-python
    python-dateutil
    pytz
    requests
    rich
  ];

  meta = with lib; {
    description = "Report on quality of SBOM contents";
    homepage = "https://github.com/anthonyharrison/sbomaudit";
    license = licenses.asl20;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
