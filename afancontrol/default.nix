{ lib, buildPythonPackage, fetchPypi, setuptools, click, pytestCheckHook, requests }:

buildPythonPackage rec {
  pname = "afancontrol";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FAOZWoSi7IgONtNspUxR4h5FnkkrNrE0N861t5LHpGw=";
  };

  pyproject = true;
  build-system = [ setuptools ];

  propagatedBuildInputs = [ click ];
  checkInputs = [ pytestCheckHook requests ];

  postInstall = ''
    substituteInPlace $out/etc/systemd/system/afancontrol.service \
      --replace "/usr/bin/afancontrol" "$out/bin/afancontrol"
  '';

  meta = with lib; {
    description = "Advanced Fan Control program, which controls PWM fans according to the current temperatures of the system components";
    homepage = "https://afancontrol.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.linux;
  };
}
