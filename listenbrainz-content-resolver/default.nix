{ lib
, buildPythonPackage
, fetchFromGitHub
, click
, mutagen
, nmslib
, peewee
, regex
, scikit-learn
, unidecode
, setuptools-scm
}:
let
  lb_matching_tools = buildPythonPackage rec {
    pname = "listenbrainz-matching-tools";
    # ensure this matches ListenBrainz-Content-Resolver’s requirements.txt entry
    version = "2023-07-19.0";

    src = fetchFromGitHub {
      owner = "metabrainz";
      repo = pname;
      rev = "v-${version}";
      sha256 = "sha256-SOUNw1kmXm8j7iZAROf+pVJao5eFjgNmgrtYMO09upA=";
    };

    propagatedBuildInputs = [
      regex
    ];

    nativeBuildInputs = [
      setuptools-scm
    ];

    SETUPTOOLS_SCM_PRETEND_VERSION = version;
  };
in
buildPythonPackage rec {
  pname = "ListenBrainz-Content-Resolver";
  version = "unstable-2023-10-03";

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = pname;
    rev = "6caa43df1d17a974ae27a91f1aaf663952cf0ed9";
    sha256 = "sha256-m11buP7AhpLXmIPK9z3r3Gtr8L6A5MAt+SyuIT5bK9Q=";
  };

  postPatch = ''
    # Make model discoverable by setuptools’ find_packages
    touch lb_content_resolver/model/__init__.py

    # pythonRelaxDepsHook does not work when this packages’ version is set to unstable-YYYY-MM-DD
    sed -i setup.py -e 's/"\([^=]*\)==[^"]*"/"\1"/g'
  '';

  propagatedBuildInputs = [
    click
    lb_matching_tools
    mutagen
    nmslib
    peewee
    regex
    scikit-learn
    unidecode
  ];
  nativeBuildInputs = [
    setuptools-scm
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  doCheck = false;

  postInstall = ''
    mkdir -p $out/bin
    cp $src/resolve.py $out/bin/lb-content-resolver
  '';

  meta = with lib; {
    description = "Resolver for ListenBrainz playlists from JSPF to local playlists";
    homepage = "https://github.com/metabrainz/listenbrainz-content-resolver";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.linux;
  };
}
