{ poetry2nix, pkgs, lib }:
let
  pythonPackages = (poetry2nix.mkPoetryPackages {
    projectDir = ./.;
    overrides = [
      poetry2nix.defaultPoetryOverrides
      (import ./poetry-git-overlay.nix { inherit pkgs; })
      (final: prev: {
        bandcamp-downloader = prev.bandcamp-downloader.overridePythonAttrs (old: {
          # HACK
          version = (builtins.fromTOML (builtins.readFile ./pyproject.toml)).tool.poetry.dependencies.bandcamp-downloader.tag;

          postInstall = ''
            mv $out/bin/${old.pname}{.py,}
          '';

          meta = old.meta // (with lib; {
            description = "Download your bandcamp collection using this python script";
            license = licenses.mit;
            homepage = "https://github.com/easlice/bandcamp-downloader";
            maintainers = with maintainers; [ sbruder ];
            platforms = platforms.linux;
          });
        });
        beautifulsoup4 = prev.beautifulsoup4.overridePythonAttrs (old: {
          propagatedBuildInputs = old.propagatedBuildInputs ++ (with prev; [
            setuptools
            hatchling
          ]);
        });
        backports-tarfile = prev.backports-tarfile.overridePythonAttrs (old: {
          propagatedBuildInputs = old.propagatedBuildInputs ++ (with prev; [
            setuptools
          ]);
        });
      })
    ];
  }).python.pkgs;
in
pythonPackages.bandcamp-downloader
