{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "netbox-topology-views";
  version = "3.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-w10iz19235dMIj7VM7w2beaPyENuDXhKQ421vZ0QCcc=";
  };

  doCheck = false;

  meta = with lib; {
    description = "A netbox plugin that draws topology views";
    homepage = "https://github.com/mattieserver/netbox-topology-views";
    license = licenses.asl20;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.linux;
  };
}
