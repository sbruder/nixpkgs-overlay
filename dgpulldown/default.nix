{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "dgpulldown";
  version = "1.0.11-L";

  src = fetchzip {
    url = "https://renomath.org/video/linux/interlace/dgpulldown4unix.tgz";
    hash = "sha256-enHc4wizqpmeitB95ZI6v68a1oYT3HsHDZr2uAIoROU=";
  };

  patches = [
    ./headers.patch
  ];

  buildPhase = ''
    runHook preBuild

    gcc -O3 -o ${pname} ${pname}.c

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D ${pname} $out/bin/${pname}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Change interlacing fields on MPEG2 bitstreams";
    homepage = "https://renomath.org/video/linux/interlace/check.html";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.unix;
  };
}
