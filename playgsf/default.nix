{ lib, stdenv, fetchzip, fetchpatch, libao, libresample, zlib }:

stdenv.mkDerivation rec {
  pname = "playgsf";
  version = "0.7.1";

  src = fetchzip {
    url = "http://projects.raphnet.net/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1y7qs2fnmlf2z8abb6190ga958vak33s3n4xrndg9zakdahi03ff";
  };

  patches = [
    ./no-bundled-libresample.patch
    # Make compile with newer GCC that does not allow invalid code
    (fetchpatch {
      name = "fixes.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/fixes.patch?h=playgsf&id=1d613d3923987b39ca81636650038e670b712b29";
      sha256 = "sha256-0sWvb/qF6LLtd2LfpLGwH/MKAjDKuElfXRGBlDrwYoU=";
    })
  ];

  nativeBuildInputs = [ ];
  buildInputs = [ libao libresample zlib ];

  # nixpkgs version of libresample is used
  postPatch = ''
    rm -r libresample-0.1.3
  '';

  # remove libresample
  postConfigure = ''
    substituteInPlace Makefile \
        --replace "-I./libresample-0.1.3/include" "" \
        --replace "-L./libresample-0.1.3" ""
  '';

  # if optimisations are on, a segfault in VBA/Util.o:585 (fread) occurs
  # !!! HACK: re-compile that object without optimisations and link the main
  # binary again
  postBuild = ''
    g++ -DLINUX -O0 -c VBA/Util.cpp -o VBA/Util.o
    make
  '';

  installPhase = ''
    runHook preInstall
    install -D playgsf $out/bin/playgsf
    runHook postInstall
  '';

  meta = with lib; {
    description = "A simple command line player for gsf files based on the winamp plugin ‘Highly Advanced’";
    homepage = "http://projects.raphnet.net/#playgsf";
    license = with licenses; [ gpl2Plus mit unfree ]; # some files do not have license header and no global license
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.unix;
  };
}
