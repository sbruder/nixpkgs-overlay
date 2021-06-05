{ lib, stdenv, fetchFromGitHub, pkg-config, which, curl, gettext, libxml2, ncurses, openssl }:

stdenv.mkDerivation rec {
  pname = "snownews";
  version = "unstable-2021-06-05";

  src = fetchFromGitHub {
    owner = "msharov";
    repo = pname;
    rev = "0c0bce7d59fa4fc6d66b4472682d7afcec59c9fb";
    sha256 = "1cp0igx433vwbrh1igc9vr1xbfnfwn0312dnhfvbciqk0ss5wij7";
  };

  nativeBuildInputs = [ pkg-config which ];
  buildInputs = [ curl gettext libxml2 ncurses openssl ];

  meta = with lib; {
    description = "A text-mode RSS feed reader";
    homepage = "https://github.com/msharov/snownews";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.unix;
  };
}
