final: prev:
let
  inherit (prev) callPackage;

  callPythonPackage = prev.python3Packages.callPackage;
in
{
  python3 = prev.python3.override {
    packageOverrides = final: prev:
      {
        deezer-py = callPythonPackage ./python-modules/deezer-py { };

        enlighten = callPythonPackage ./python-modules/enlighten { };

        prefixed = callPythonPackage ./python-modules/prefixed { };
      };
  };
  python3Packages = prev.recurseIntoAttrs final.python3.pkgs;

  cyanrip = callPackage ./cyanrip { };

  deemix = callPythonPackage ./deemix { };

  fSpy = callPackage ./fSpy { };

  face_morpher = callPythonPackage ./face_morpher { };

  mpvScripts = prev.mpvScripts // {
    pitchcontrol = callPackage ./mpv-scripts/pitchcontrol { };
  };

  nsz = callPythonPackage ./nsz { };

  oha = callPackage ./oha { };

  rlvm = callPackage ./rlvm { };

  snownews = callPackage ./snownews { };

  textidote = callPackage ./textidote { };

  unxwb = callPackage ./unxwb { };

  vgmstream = callPackage ./vgmstream { };

  VisiCut = callPackage ./VisiCut { };

  x264-unstable = prev.x264.overrideAttrs (callPackage ./x264-unstable { });
}
