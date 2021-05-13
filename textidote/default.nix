{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "textidote";
  version = "0.8.2";

  src = fetchurl {
    url = "https://github.com/sylvainhalle/textidote/releases/download/v${version}/${pname}.jar";
    sha256 = "1h1fxllzv0hi4g1yf1hfsdga79z46g41n596k8c87yqq7l841s3n";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share
    cp $src $out/share/${pname}.jar
    makeWrapper ${jre}/bin/java $out/bin/${pname} --add-flags "-jar $out/share/${pname}.jar"
  '';

  meta = with lib; {
    description = "A spelling, grammar and style checker for LaTeX documents";
    homepage = "https://sylvainhalle.github.io/textidote/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
