{ lib, buildPythonPackage, fetchPypi, setuptools }:

buildPythonPackage rec {
  pname = "netbox-inventory";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mdfK8FQ8srpLebwX2YEA/kdfDVU1xDbyYnq2gUqUcws=";
  };

  format = "pyproject";

  nativeBuildInputs = [ setuptools ];

  meta = with lib; {
    description = "Manage your hardware inventory in NetBox";
    homepage = "https://github.com/ArnesSI/netbox-inventory";
    license = licenses.mit;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.linux;
  };
}
