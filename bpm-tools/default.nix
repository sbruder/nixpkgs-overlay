# Adapted from upstream nixpkgs
{ lib
, stdenv
, flac
, gnuplot
, id3v2
, opustags
, sox
, vorbis-tools
, fetchFromForgejo
, makeWrapper
}:

let
  path = lib.makeBinPath [
    flac
    gnuplot
    id3v2
    opustags
    sox
    vorbis-tools
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "bpm-tools";
  version = "0.4.1";

  src = fetchFromForgejo {
    domain = "git.sbruder.de";
    owner = "simon";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-QGHzaH8FGDEauMudnyvhSREbQdbTzFNC1+eV5pZmX18=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  postFixup = ''
    wrapProgram $out/bin/bpm-tag --prefix PATH : "${path}"
    wrapProgram $out/bin/bpm-graph --prefix PATH : "${path}"
  '';

  meta = {
    homepage = "http://www.pogo.org.uk/~mark/bpm-tools/";
    description = "Automatically calculate BPM (tempo) of music files";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
  };
})
