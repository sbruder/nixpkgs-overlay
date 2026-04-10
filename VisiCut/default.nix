{ lib, stdenv, fetchzip, makeWrapper, wrapGAppsHook3, glib, jdk11 }:

stdenv.mkDerivation rec {
  pname = "VisiCut";
  version = "1.9-216";

  src = fetchzip {
    url = "https://github.com/t-oster/${pname}/releases/download/${version}/VisiCut-${version}-g30b4dc81.zip";
    sha256 = "sha256-PGYW7gO6dHw0XcsNQPCq2twAItEG89ME6V7BKz2VBxA=";
  };

  nativeBuildInputs = [ makeWrapper wrapGAppsHook3 ];
  buildInputs = [ glib jdk11 ];

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    rm ${pname}.{exe,Linux,MacOS}
    mkdir -p $out/share
    cp -r . $out/share/${pname}

    runHook postInstall
  '';

  # Needs to be run in fixupPhase, since gappsWrapperArgs are not fully
  # populated in installPhase yet.
  postFixup = ''
    makeWrapper \
        ${jdk11}/bin/java \
        $out/bin/${pname} \
        --add-flags "-Xms256m -Xmx2048m -jar $out/share/${pname}/Visicut.jar" \
        "''${gappsWrapperArgs[@]}"
  '';

  meta = with lib; {
    description = "A userfriendly tool to prepare, save and send Jobs to Lasercutters";
    homepage = "https://visicut.org/";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
