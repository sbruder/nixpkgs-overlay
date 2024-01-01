{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libjack2
, libsndfile
, lv2
, readline
}:

stdenv.mkDerivation rec {
  pname = "liquidsfz";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "swesterfeld";
    repo = pname;
    rev = version;
    sha256 = "sha256-yIkHUg6q6d+YS9x0+fWEhl65urT9KI73y+W71g2SOoA=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [
    libjack2
    libsndfile
    lv2
    readline
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "SFZ sampler";
    homepage = "https://github.com/cnlohr/colorchord";
    license = licenses.mpl20;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
