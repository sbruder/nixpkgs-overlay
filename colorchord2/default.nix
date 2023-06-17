{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, alsa-lib
, freeglut
, libusb1
, pulseaudio
, xorg
}:

stdenv.mkDerivation rec {
  pname = "colorchord";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "cnlohr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-C+xx0TJf0/y/fqdfSsJ7i1bnPQODYcxY9XM4l3DQ0UY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    alsa-lib
    freeglut
    libusb1
    pulseaudio
  ] ++ (with xorg; [
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
