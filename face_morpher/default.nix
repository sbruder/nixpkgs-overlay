{ lib, fetchurl, runCommandNoCC, buildPythonPackage, fetchFromGitHub, setuptools, dlib, docopt, matplotlib, numpy, opencv4, scipy, model ? null }:
let
  model' = if !isNull model then model else
  fetchurl {
    url = "http://dlib.net/files/shape_predictor_68_face_landmarks.dat.bz2";
    sha256 = "0bxr25mp6zpzk6icgrmnx7ph0qxs6bdgvjvjhrspmamr1sw2rp7v";
    downloadToTemp = true;
    postFetch = ''
      bzcat $downloadedFile > $out
    '';
  };

  modelDir = runCommandNoCC "face_morpher-models" { } ''
    install -Dm 444 ${lib.escapeShellArg model'} "$out/shape_predictor_68_face_landmarks.dat"
  '';
in
buildPythonPackage rec {
  pname = "face_morpher";
  version = "unstable-2019-06-30";

  src = fetchFromGitHub {
    owner = "alyssaq";
    repo = pname;
    rev = "7a30611cd9d33469e843cec9cfa23ccf819386a8";
    sha256 = "09ahar661r5046gr3qsv2z22x50jz1bv116ci55fsvcjzv64rygw";
  };

  pyproject = true;
  build-system = [ setuptools ];

  propagatedBuildInputs = [
    dlib
    docopt
    matplotlib
    numpy
    opencv4
    scipy
  ];

  makeWrapperArgs = [ "--set DLIB_DATA_DIR ${lib.escapeShellArg modelDir}" ];

  doCheck = false;

  meta = with lib; {
    description = "A warper, morpher and averager for human faces";
    homepage = "https://github.com/alyssaq/face_morpher";
    license = licenses.mit;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.linux;
  };
}
