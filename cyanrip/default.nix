{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, ffmpeg
, libcdio
, libcdio-paranoia
, curl
, libmusicbrainz5
}:

stdenv.mkDerivation rec {
  pname = "cyanrip";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "cyanreg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ ffmpeg libcdio libcdio-paranoia curl libmusicbrainz5 ];

  meta = with lib; {
    description = "Fully featured CD ripping program able to take out most of the tedium";
    homepage = "https://github.com/cyanreg/cyanrip";
    license = with licenses; [ lgpl21Plus lgpl3Plus ]; # some files have lgpl21Plus header, repo has lgpl3Plus LICENSE
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.unix;
  };
}
