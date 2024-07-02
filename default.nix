final: prev:
let
  inherit (prev) callPackage;

  callPythonPackage = prev.python3Packages.callPackage;
in
rec {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ (prev.lib.singleton (final: prev: {
    enlighten = callPythonPackage ./python-modules/enlighten { };

    netbox-inventory = callPythonPackage ./python-modules/netbox-inventory { };

    netbox-topology-views = callPythonPackage ./python-modules/netbox-topology-views { };

    nmslib = callPythonPackage ./python-modules/nmslib { };

    prefixed = callPythonPackage ./python-modules/prefixed { };
  }));

  afancontrol = callPythonPackage ./afancontrol { };

  bandcamp-downloader = callPackage ./bandcamp-downloader { };

  colorchord2 = callPackage ./colorchord2 { };

  cups-sii-slp-400-600 = callPackage ./cups-sii-slp-400-600 { };

  fSpy = callPackage ./fSpy { };

  face_morpher = callPythonPackage ./face_morpher { };

  gust_tools = callPackage ./gust_tools { };

  hcloud_exporter = callPackage ./hcloud_exporter { };

  linuxmotehook2 = callPackage ./linuxmotehook2 { };

  listenbrainz-content-resolver = callPythonPackage ./listenbrainz-content-resolver { };

  liquidsfz = callPackage ./liquidsfz { };

  mdbook-svgbob = callPackage ./mdbook-svgbob { };

  mpvScripts = prev.mpvScripts // {
    pitchcontrol = callPackage ./mpv-scripts/pitchcontrol { };
  };

  netstick = callPackage ./netstick { };

  nsz = callPythonPackage ./nsz { };

  playgsf = callPackage ./playgsf { };

  textidote = callPackage ./textidote { };

  unxwb = callPackage ./unxwb { };

  VisiCut = callPackage ./VisiCut { };

  wa-crypt-tools = callPythonPackage ./wa-crypt-tools { };

  whisper_cpp = callPackage ./whisper_cpp { };
}
