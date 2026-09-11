# SPDX-FileCopyrightText: 2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ lib, rustPlatform, fetchFromGitLab }:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wkd-exporter";
  version = "0.3.3";

  src = fetchFromGitLab {
    domain = "gitlab.archlinux.org";
    owner = "archlinux";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-UyA+wTKJKE94qTt8mYXyzoBaRJHEuMaBJ8JYzQoshcI=";
  };

  cargoHash = "sha256-WMxehyCE67b0/vZ2AluFAvhOSyLHQfjtWqAzMCUjBEE=";

  meta = {
    description = "Exports an OpenPGP keyring into an advanced WKD directory path";
    homepage = "https://gitlab.archlinux.org/archlinux/wkd-exporter";
    license = with lib.licenses; [ asl20 mit ];
    maintainers = with lib.maintainers; [ sbruder ];
    platforms = lib.platforms.linux;
  };
})
