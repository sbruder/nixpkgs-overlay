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

  colorchord2 = callPackage ./colorchord2 { };

  deemix = callPythonPackage ./deemix { };

  fSpy = callPackage ./fSpy { };

  face_morpher = callPythonPackage ./face_morpher { };

  gust_tools = callPackage ./gust_tools { };

  hcloud_exporter = callPackage ./hcloud_exporter { };

  linuxmotehook2 = callPackage ./linuxmotehook2 { };

  mpvScripts = prev.mpvScripts // {
    pitchcontrol = callPackage ./mpv-scripts/pitchcontrol { };
  };

  netstick = callPackage ./netstick { };

  nsz = callPythonPackage ./nsz { };

  playgsf = callPackage ./playgsf { };

  textidote = callPackage ./textidote { };

  unxwb = callPackage ./unxwb { };

  vgmstream = callPackage ./vgmstream { };

  VisiCut = callPackage ./VisiCut { };
}
