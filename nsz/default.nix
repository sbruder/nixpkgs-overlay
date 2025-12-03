{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, pycryptodome
, zstandard
, enlighten
}:

buildPythonPackage rec {
  pname = "nsz";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gckszvkjklrslidpfidbzcigpwwj4s0chrnrg16wvh3r93aiaci";
  };

  pyproject = true;
  build-system = [ setuptools ];

  propagatedBuildInputs = [
    pycryptodome
    zstandard
    enlighten
  ];

  doCheck = false; # requires keys

  meta = with lib; {
    description = "A homebrew compatible NSP/XCI compressor/decompressor";
    homepage = "https://github.com/nicoboss/nsz";
    license = licenses.mit;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
