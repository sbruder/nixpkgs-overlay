{ lib
, stdenv
, fetchFromGitHub
, scons
, pkg-config
, SDL
, SDL_image
, SDL_mixer
, SDL_ttf
, boost
, freetype
, glew
, gtk2
, libogg
, libsndfile
, libvorbis
, zita-resampler
}:

stdenv.mkDerivation rec {
  pname = "rlvm";
  # there has been no release since 2014, but important updates (like python 3
  # support) have been made since then
  version = "unstable-2021-05-27";

  src = fetchFromGitHub {
    owner = "eglaysher";
    repo = pname;
    rev = "fabf134a8023e6bb20473882a123666060b6187c";
    sha256 = "1y1l1hwcab8ln3rz4qlz3kl85l4byf0w00ysblki7lfsqm79lq3h";
  };

  patches = [
    ./0001-Include-OS-environment-in-SCons-environment.patch
  ];

  nativeBuildInputs = [
    scons
    pkg-config
  ];
  buildInputs = [
    SDL
    # FIXME: They are not recognised by SCons
    #SDL_image
    #SDL_mixer
    #SDL_ttf
    boost
    freetype
    glew
    gtk2
    libogg
    libsndfile
    libvorbis
    zita-resampler
  ];

  sconsFlags = [
    "--release"
  ];

  installPhase = ''
    runHook preInstall
    install -D build/release/rlvm $out/bin/rlvm
    runHook postInstall
  '';

  meta = with lib; {
    description = "RealLive clone for Linux and OSX";
    homepage = "http://www.rlvm.net/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.unix;
  };
}
