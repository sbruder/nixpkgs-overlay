{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, numpy
, psutil
, pybind11
}:

buildPythonPackage rec {
  pname = "nmslib";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-lxKUp3ZvkcaX1jyIyK3aR5epRDRsxTWiFzk/QWehnCA=";
  };

  patchFlags = [ "-p2" ];
  patches = [
    # Fix import on newer versions of pybind11 (https://github.com/nmslib/nmslib/pull/488)
    (fetchpatch {
      url = "https://github.com/nmslib/nmslib/commit/574ecd54c157d13aecc03033311be261c91a45ec.patch";
      sha256 = "sha256-R/y6BbnZRe7VM5XCbes6Z5A5N66r+8SCA2Hy6K301IM=";
    })
  ];

  propagatedBuildInputs = [
    numpy
    psutil
    pybind11
  ];

  meta = with lib; {
    description = "An efficient similarity search library and a toolkit for evaluation of their methods";
    homepage = "https://github.com/nmslib/nmslib";
    license = licenses.asl20;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
