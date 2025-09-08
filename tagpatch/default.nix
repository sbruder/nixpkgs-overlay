{ lib, buildPythonPackage, fetchPypi, hatchling, click, music-tag, mutagen, tabulate, pytestCheckHook }:

buildPythonPackage rec {
  pname = "tagpatch";
  version = "0.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-TfheL4q6PVEQzQn15kCCLZYsYjW59cazEd+HSLhX9Zs=";
  };

  format = "pyproject";
  build-system = [ hatchling ];

  propagatedBuildInputs = [ click music-tag mutagen tabulate ];
  checkInputs = [ pytestCheckHook ];

  pythonRelaxDeps = [
    "click"
    "mutagen"
  ];

  meta = with lib; {
    description = "CLI tool which applies common patches to music tags";
    homepage = "https://github.com/IceWreck/tagpatch";
    license = licenses.mit;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.linux;
  };
}
