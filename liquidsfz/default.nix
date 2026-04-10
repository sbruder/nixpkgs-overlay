{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libGL
, libjack2
, libsndfile
, libx11
, libxcursor
, libxext
, libxrandr
, lv2
, readline
}:

stdenv.mkDerivation rec {
  pname = "liquidsfz";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "swesterfeld";
    repo = pname;
    rev = version;
    sha256 = "sha256-6E3JT/pWQ1p4RsF9zW2rpOEYn8kCUojVHee7JMZ92wY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [
    libGL
    libjack2
    libsndfile
    libx11
    libxcursor
    libxext
    libxrandr
    lv2
    readline
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "SFZ sampler";
    homepage = "https://github.com/swesterfeld/liquidsfz";
    license = licenses.mpl20;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
