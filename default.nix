final: prev:
let
  inherit (prev) callPackage;

  callPythonPackage = prev.python3Packages.callPackage;
in
rec {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ (prev.lib.singleton (final: prev: {
    creart = callPythonPackage ./python-modules/creart { };

    dataclass-click = callPythonPackage ./python-modules/dataclass-click { };

    netbox-inventory = callPythonPackage ./python-modules/netbox-inventory { };

    netbox-topology-views = callPythonPackage ./python-modules/netbox-topology-views { };

    nmslib = callPythonPackage ./python-modules/nmslib { };

    pymp4 = callPythonPackage ./python-modules/pymp4 { };

    pywidevine = callPythonPackage ./python-modules/pywidevine { };
  }));

  afancontrol = callPythonPackage ./afancontrol { };

  cups-sii-slp-400-600 = callPackage ./cups-sii-slp-400-600 { };

  face_morpher = callPythonPackage ./face_morpher { };

  feishin-web = callPackage ./feishin-web { };

  gamdl = callPythonPackage ./gamdl { };

  gust_tools = callPackage ./gust_tools { };

  haproxy-auth-request = callPackage ./haproxy-auth-request { };

  haproxy-lua-cors = callPackage ./haproxy-lua-cors { };
  haproxy-lua-http = callPackage ./haproxy-lua-http { };

  hcloud_exporter = callPackage ./hcloud_exporter { };

  knst0-mdl = callPackage ./knst0-mdl { };

  komf = callPackage ./komf { };

  linuxmotehook2 = callPackage ./linuxmotehook2 { };

  liquidsfz = callPackage ./liquidsfz { };

  luajson = prev.luaPackages.callPackage ./luajson { };

  mdbook-svgbob = callPackage ./mdbook-svgbob { };

  mpvScripts = prev.mpvScripts // {
    pitchcontrol = callPackage ./mpv-scripts/pitchcontrol { };
  };

  netstick = callPackage ./netstick { };

  nsz = callPythonPackage ./nsz { };

  pyplayready = callPythonPackage ./pyplayready { };

  rtl-wmbus = callPackage ./rtl-wmbus { };

  sbomaudit = callPythonPackage ./sbomaudit { };

  sbom2doc = callPythonPackage ./sbom2doc { };

  textidote = callPackage ./textidote { };

  unxwb = callPackage ./unxwb { };

  VisiCut = callPackage ./VisiCut { };

  wa-crypt-tools = callPythonPackage ./wa-crypt-tools { };

  whisper_cpp = callPackage ./whisper_cpp { };

  wmbusmeters = callPackage ./wmbusmeters { };
}
