# SPDX-FileCopyrightText: 2021 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ lib, stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "gust_tools";
  version = "1.58";

  src = fetchFromGitHub {
    owner = "VitaSmith";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kH/YVS/ArvwNE21uYzoaZh+WY5fD+6xHeTl9SSM2B1E=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/VitaSmith/gust_tools/commit/1532f65aeba4e64774547bd552933185b34d23a0.patch";
      sha256 = "sha256-ck7R6iHafFjCOT6hiR85ta/CgA3Xxj6wrXpSrqByR9o=";
    })
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp gust_{ebm,elixir,enc,g1t,pak} $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    description = "A set of utilities for dealing with Gust (Koei Tecmo) PC games files";
    homepage = "https://github.com/VitaSmith/gust_tools";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.unix;
  };
}
