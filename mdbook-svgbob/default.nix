# SPDX-FileCopyrightText: 2024 Simon Bruder <simon@sbruder.de>
# SPDX-FileCopyrightText: 2025 Xavier Ruiz <github@xav.ie>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-svgbob";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "boozook";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5V8mTyIyKS/AgfGIM8oiVFvq/9cBlmxhUuBir71GElQ=";
  };

  cargoHash = "sha256-XPAzYIo2bAVRex2WB8LI4QEy+NH5RPUkBkybu/B/mac=";

  meta = {
    description = "SvgBob mdbook preprocessor which swaps code-blocks with SVG";
    homepage = "https://github.com/boozook/mdbook-svgbob";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ sbruder ];
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
}
