# SPDX-FileCopyrightText: 2021-2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix/master";
    nix-pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";

    poetry2nix.url = "github:nix-community/poetry2nix";
    poetry2nix.inputs.flake-utils.follows = "flake-utils";
    poetry2nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, flake-utils, nixpkgs, nix-pre-commit-hooks, poetry2nix }: {
    overlays.default = import ./default.nix;

    nixosModules =
      let
        inherit (nixpkgs) lib;
      in
      {
        cap.imports = lib.singleton ./cap/module.nix;
        komf.imports = lib.singleton ./komf/module.nix;
        mcaptcha.imports = lib.singleton ./mcaptcha/module.nix;
        network-journal.imports = lib.singleton ./network-journal/module.nix;
      };
  } // flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlays.default poetry2nix.overlays.default ];
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
            reuse.enable = true;
          };
        };
      };

      devShell = pkgs.mkShell {
        inherit (checks.pre-commit-check) shellHook;
        buildInputs = checks.pre-commit-check.enabledPackages;
      };

      packages = lib.filterAttrs
        (n: v: lib.elem system v.meta.platforms)
        (flake-utils.lib.flattenTree {
          inherit (pkgs)
            VisiCut
            afancontrol
            aonsoku-web
            bpm-tools
            cap
            cups-sii-slp-400-600
            dgpulldown
            face_morpher
            fedifetcher
            feishin-web
            gamdl
            gust_tools
            haproxy-auth-request
            haproxy-lua-cors
            haproxy-lua-http
            knst0-mdl
            komf
            linuxmotehook2
            liquidsfz
            luajson
            mcaptcha
            mcaptcha-cache
            mdbook-svgbob
            netstick
            network-journal
            pyplayready
            pywidevine
            rtl-wmbus
            sbom2doc
            sbomaudit
            single-file-cli
            tsmuxer
            ttconv
            unxwb
            wa-crypt-tools
            wmbusmeters;

          mpvScripts = lib.recurseIntoAttrs {
            inherit (pkgs.mpvScripts)
              pitchcontrol;
          };
        });

      apps = {
        check-all-packages = {
          type = "app";
          program = toString (pkgs.writeShellScript "check-all-packages" ''
            set -euo pipefail
            fail=0

            eval_result="$(${pkgs.nix-eval-jobs}/bin/nix-eval-jobs --flake ${self}#packages.${system})"
            ${pkgs.jq}/bin/jq -s -r '.[] | select(has("drvPath")) | "${self}#\(.attr)"' <<< "$eval_result" | xargs nix build --no-link --keep-going || true
            ${pkgs.jq}/bin/jq -s -r '.[] | select(has("error")) | .attr' <<< "$eval_result" | while read drv; do
              fail=1
              echo "❌ $drv (failed evaluation)" >&2
            done
            ${pkgs.jq}/bin/jq -s -r '.[] | select(has("drvPath")) | .attr + " " + .outputs.out' <<< "$eval_result" | while read drv; do
              attr="$(cut -d" " -f1 <<< "$drv")"
              outPath="$(cut -d" " -f2 <<< "$drv")"
              if [ -e "$outPath" ]; then
                echo "✅ $attr" >&2
              else
                fail=1
                echo "❌ $attr (failed build)" >&2
              fi
            done
            exit "$fail"
          '');
        };
      };
    });
}
