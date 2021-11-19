{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, alsa-lib
, freeglut
, libusb
, pulseaudio
, xlibs
}:

stdenv.mkDerivation rec {
  pname = "colorchord";
  version = "unstable-2021-11-12";

  src = fetchFromGitHub {
    owner = "cnlohr";
    repo = pname;
    rev = "0a44c600243636ef8fbaf11c728c49412e8ad8d4";
    sha256 = "sha256-a9nOdj7Q8vDoseoE+u5/DWRxSCXiSxs/7r74PcoDc2k=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    alsa-lib
    freeglut
    libusb
    pulseaudio
  ] ++ (with xlibs; [
    libX11
    libXext
    libXinerama
  ]);

  postPatch = ''
    substituteInPlace colorchord2/configs.c \
        --replace "default.conf" "$out/share/colorchord2/default.conf"
  '';

  # settings sourceRoot makes the rest read-only, which breaks the build
  preBuild = ''
    cd colorchord2
  '';

  makeFlags = [ "colorchord" "colorchord-opengl" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/colorchord2}

    cp colorchord{,-opengl} $out/bin/
    cp *.conf $out/share/colorchord2/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Chromatic Sound to Light Conversion System";
    homepage = "https://github.com/cnlohr/colorchord";
    license = licenses.free; # 3-clause BSD license with modified 3rd clause (https://github.com/cnlohr/colorchord/blob/master/LICENSE)
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
