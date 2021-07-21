{ lib
, buildPythonPackage
, fetchPypi
, blessed
, prefixed
}:

buildPythonPackage rec {
  pname = "enlighten";
  version = "1.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1159iqivln12sfbf0bc2iyaf8ic7nj1694nnsp7fsjinhrjr349k";
  };

  propagatedBuildInputs = [
    blessed
    prefixed
  ];

  meta = with lib; {
    description = "A progress Bar for Python Console Apps";
    homepage = "https://python-enlighten.readthedocs.io";
    license = licenses.mpl20;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
