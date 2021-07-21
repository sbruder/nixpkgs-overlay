{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "prefixed";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0af0sanqdw7ymy9rxhw7cd0q8yqcjgd4f23n9gfld0zslmxjfj6a";
  };

  meta = with lib; {
    description = "A prefixed alternative numeric library";
    homepage = "https://github.com/Rockhopper-Technologies/prefixed";
    license = licenses.mpl20;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
