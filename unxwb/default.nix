{ lib, stdenv, fetchzip, zlib }:

stdenv.mkDerivation rec {
  pname = "unxwb";
  version = "0.3.6";

  src = fetchzip {
    # upstream URL (https://aluigi.altervista.org/papers/unxwb.zip) is not stable
    url = "https://web.archive.org/web/20210401211235if_/http://aluigi.altervista.org/papers/unxwb.zip";
    sha256 = "1i7m7dacfnjs22d0vk49ljmszxcvrqfr6x9brpp0qfggvqdfaw55";
    stripRoot = false;
  };

  buildInputs = [ zlib ];

  buildPhase = ''
    runHook preBuild

    gcc -lz -I. -O3 -o ${pname} ${pname}.c

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D ${pname} $out/bin/${pname}

    runHook postInstall
  '';

  meta = with lib; {
    description = "A tool for extracting the data contained in XWB archives";
    homepage = "https://aluigi.altervista.org/papers.htm";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
