{ lib
, stdenv
, fetchurl
, makeWrapper
, jdk17
}:
let
  jre = jdk17;
in
stdenv.mkDerivation rec {
  pname = "komf";
  version = "1.7.1";

  src = fetchurl {
    url = "https://github.com/Snd-R/${pname}/releases/download/${version}/${pname}-${version}.jar";
    hash = "sha256-reVCSNj4FlKILXSRuRw/m7uv/SjTXS0Ch1snrNWJBNE=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildCommand = ''
    makeWrapper ${jre}/bin/java $out/bin/komf --add-flags "-jar $src"
  '';

  meta = {
    description = "Komga and Kavita metadata fetcher";
    homepage = "https://github.com/Snd-R/komf";
    license = lib.licenses.mit;
    platforms = jre.meta.platforms;
    maintainers = with lib.maintainers; [ sbruder ];
    mainProgram = "komf";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
}
