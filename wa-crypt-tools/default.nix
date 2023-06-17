#{ lib
#, buildPythonPackage
#, fetchPypi
#, setuptools
#, javaobj-py3
#, protobuf
#}:
#
#buildPythonPackage rec {
#  pname = "wa-crypt-tools";
#  version = "0.0.8";
#
#  src = fetchPypi {
#    inherit pname version;
#    sha256 = "sha256-H5uSVKtmcR+xZ+CWgpfUyF+YdO/s4VB7YV6r0ZX39/8=";
#  };
#
#  format = "pyproject";
#
#  nativeBuildInputs = [
#    setuptools
#  ];
#
#  propagatedBuildInputs = [
#    javaobj-py3
#    prtobuf
#  ];
#
#  meta = with lib; {
#    description = "Decryptor for WhatsApp’s databases";
#    homepage = "https://github.com/ElDavoo/wa-crypt-tools";
#    license = licenses.gpl3Only;
#    maintainers = with maintainers; [ sbruder ];
#    platforms = platforms.all;
#  };
#}
{ poetry2nix, pkgs, lib }:
let
  pythonPackages = (poetry2nix.mkPoetryPackages {
    projectDir = ./.;
    overrides = [
      poetry2nix.defaultPoetryOverrides
      #(import ./poetry-git-overlay.nix { inherit pkgs; })
      (final: prev: {
        wa-crypt-tools = prev.wa-crypt-tools.overridePythonAttrs (old: {
          propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ prev.setuptools ];
          #postInstall = ''
          #  install -D ${old.pname}.py $out/bin/${old.pname}
          #'';

          meta = old.meta // (with lib; {
            description = "Decryptor for WhatsApp’s databases";
            homepage = "https://github.com/ElDavoo/wa-crypt-tools";
            license = licenses.gpl3Only;
            maintainers = with maintainers; [ sbruder ];
            platforms = platforms.all;
          });
        });
      })
    ];
  }).python.pkgs;
in
pythonPackages.wa-crypt-tools
