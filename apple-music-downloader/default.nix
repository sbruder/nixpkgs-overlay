# SPDX-FileCopyrightText: 2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ lib, buildGoModule, fetchFromGitHub, makeWrapper, bento4, ffmpeg, gpac }:

buildGoModule (finalAttrs: {
  pname = "apple-music-downloader";
  version = "unstable-2026-07-15";

  src = fetchFromGitHub {
    owner = "zhaarey";
    repo = finalAttrs.pname;
    rev = "5b530551e61166cdeadc7e281f91992468df79fd";
    hash = "sha256-MXT1xSSykjKxQuVnN7knBIiH4JFihd6LDR06ahZMa0w=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    mv $out/bin/main $out/bin/apple-music-downloader
    wrapProgram $out/bin/apple-music-downloader \
      --prefix PATH : ${lib.makeBinPath [
        bento4 # mp4decrypt
        ffmpeg
        gpac # mp4box
      ]}
  '';

  vendorHash = "sha256-uD4Bh1pD5UEERWtfIsLD6Pu/vcF5yMNtPW8G+EGTMcM=";

  meta = with lib; {
    description = "Apple Music ALAC / Dolby Atmos / AAC / MV Downloader";
    homepage = "https://github.com/zhaarey/apple-music-downloader";
    license = licenses.unfree;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.linux;
  };
})
