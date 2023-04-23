{ poetry2nix, pkgs, lib }:
let
  pythonPackages = (poetry2nix.mkPoetryPackages {
    projectDir = ./.;
    overrides = [
      poetry2nix.defaultPoetryOverrides
      (import ./poetry-git-overlay.nix { inherit pkgs; })
      (final: prev: {
        bandcamp-downloader = prev.bandcamp-downloader.overridePythonAttrs (old: {
          postInstall = ''
            install -D ${old.pname}.py $out/bin/${old.pname}
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
      })
    ];
  }).python.pkgs;
in
pythonPackages.bandcamp-downloader
