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
, pythonRelaxDepsHook
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
  # FIXME
  # This should actually reflect the real version.
  # As there currently are no tagged versions,
  # this needs to be forged,
  # because pythonRelaxDepsHook has problems with unstable-YYYY-MM-DD as a version.
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = pname;
    rev = "50d55485d43fe3bdf2fb3a4546b3c0031edf85ee";
    sha256 = "sha256-mm8zHF87S13bzeSfWKHgO/cU3ulvA7I8h5EFsnBIVMo=";
  };

  postPatch = ''
    # Make model discoverable by setuptools’ find_packages
    touch lb_content_resolver/model/__init__.py
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
    pythonRelaxDepsHook
    setuptools-scm
  ];

  pythonRelaxDeps = true;

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  doCheck = false;

  postInstall = ''
    mkdir -p $out/bin
    cp $src/resolve.py $out/bin/${pname}
  '';

  meta = with lib; {
    description = "Resolver for ListenBrainz playlists from JSPF to local playlists";
    homepage = "https://github.com/metabrainz/listenbrainz-content-resolver";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.linux;
  };
}
