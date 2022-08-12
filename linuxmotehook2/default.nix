{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, vala, glib, libgee, systemd }:

stdenv.mkDerivation rec {
  pname = "linuxmotehook2";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "v1993";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uJ+dHA2D/Mt74H76L5+ZP78uYejudxjQK3xkUpaLDkI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ meson ninja pkg-config vala ];
  buildInputs = [ glib libgee systemd.dev ];

  meta = with lib; {
    description = "Cemuhook UDP server for WiiMotes on Linux";
    homepage = "https://github.com/v1993/linuxmotehook2";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.linux;
  };
}
