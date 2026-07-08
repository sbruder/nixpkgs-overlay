# SPDX-FileCopyrightText: 2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ lib, rustPlatform, fetchFromGitHub, pkg-config, openssl }:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "network-journal";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "nerou42";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-iflw3om45zixnfUtDY6LsdtxbScTxVehARjdZDyDz8g=";
  };

  cargoHash = "sha256-FDoMNXtjKnqzC41Gmj1JNyYR8vkJEAQyQMsenVV0y5Y=";

  patches = [
    ./0001-Print-JSON-data-on-single-line.patch
    ./0002-Allow-passing-IMAP-password-as-file.patch
    ./0003-Gracefully-handle-DMARC-parsing-error.patch
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  postPatch = ''
    substituteInPlace src/processing/derivation.rs \
      --replace-fail "/usr/share/network-journal/regexes.yaml" "$out/share/network-journal/regexes.yaml"
  '';

  postInstall = ''
    install -Dm444 regexes.yaml "$out/share/network-journal/regexes.yaml"
  '';

  checkFlags = [
    # require network connectivity
    "--skip=reports::tls_cert_validity::tests::check_expired"
    "--skip=reports::tls_cert_validity::tests::check_revoked"
    "--skip=reports::tls_cert_validity::tests::check_self_signed"
  ];

  meta = {
    description = "Collect network reports and print them to file";
    homepage = "https://github.com/nerou42/network-journal";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sbruder ];
    platforms = lib.platforms.unix;
  };
})
