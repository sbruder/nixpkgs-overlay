# SPDX-FileCopyrightText: 2019-2020 Doron Behar <doron.behar@gmail.com>
# SPDX-FileCopyrightText: 2020 Fabian Geiselhart <me@f4814n.de>
# SPDX-FileCopyrightText: 2020 Jan Tojnar <jtojnar@gmail.com>
# SPDX-FileCopyrightText: 2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT

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
