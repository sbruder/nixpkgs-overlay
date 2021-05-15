{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "pitchcontrol";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "FichteFoll";
    repo = "mpv-scripts";
    rev = "784dbafcd26455dde22175a5668c621defc14cab";
    sha256 = "057vslm6ybf0b0a5s39m049pcvb204hqf6jx1640ya2r6sm335g8";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D ${passthru.scriptName} $out/share/mpv/scripts/${passthru.scriptName}
    runHook postInstall
  '';

  passthru.scriptName = "${pname}.lua";

  meta = with lib; {
    description = "An mpv script to change the pitch of audio with keybindings";
    homepage = "https://github.com/FichteFoll/mpv-scripts";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ sbruder ];
  };
}
