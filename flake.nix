{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix/master";
    nix-pre-commit-hooks.inputs.flake-utils.follows = "flake-utils";
    nix-pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, flake-utils, nixpkgs, nix-pre-commit-hooks }: {
    overlay = import ./default.nix;

    nixosModules =
      let
        inherit (nixpkgs) lib;
      in
      {
        hcloud_exporter.imports = lib.singleton ./hcloud_exporter/module.nix;
      };
  } // flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
        config.allowUnfree = true;
      };
      lib = pkgs.lib;
    in
    rec {
      checks = {
        pre-commit-check = nix-pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true;
          };
        };
      };

      devShell = pkgs.mkShell {
        shellHook = checks.pre-commit-check.shellHook;
      };

      packages = lib.filterAttrs
        (n: v: lib.elem system v.meta.platforms)
        (flake-utils.lib.flattenTree {
          inherit (pkgs)
            VisiCut
            colorchord2
            deemix
            fSpy
            face_morpher
            gust_tools
            hcloud_exporter
            netstick
            nsz
            playgsf
            snownews
            textidote
            unxwb
            vgmstream;

          mpvScripts = lib.recurseIntoAttrs {
            inherit (pkgs.mpvScripts)
              pitchcontrol;
          };
        });

      # My hydra only has x86_64-linux builders
      hydraJobs =
        if lib.elem system [ "x86_64-linux" ]
        then packages
        else { };
    });
}
