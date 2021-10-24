{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "netstick";
  version = "unstable-2021-04-06";

  src = fetchFromGitHub {
    owner = "moslevin";
    repo = pname;
    rev = "274d510f6b058f1eeec13c3c586a891e8c4b75a4";
    sha256 = "sha256-+sI2jnkksrnoOzX621mLpLi19b3mmz3H63AIJSzuXOI=";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
        --replace "-Werror" "-Werror -Wno-stringop-truncation"
  '';

  installPhase = ''
    runHook preInstall

    install -D netstick $out/bin/netstick
    install -D netstickd $out/bin/netstickd

    runHook postInstall
  '';

  meta = with lib; {
    description = "Realtime Client/Server app allowing joystick (and other HID) data to be transferred over a local network";
    homepage = "https://github.com/moslevin/netstick";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.linux;
  };
}
