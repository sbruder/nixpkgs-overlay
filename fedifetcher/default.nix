# SPDX-FileCopyrightText: 2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ lib
, buildPythonApplication
, fetchFromGitHub
, certifi
, charset-normalizer
, defusedxml
, docutils
, idna
, iniconfig
, packaging
, pluggy
, pytest
, python-dateutil
, requests
, six
, smmap
, urllib3
, xxhash
}:

buildPythonApplication (finalAttrs: {
  pname = "fedifetcher";
  version = "7.1.18";

  src = fetchFromGitHub {
    owner = "nanos";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-6eR29MmePp3tOM7higRfSfVJFWmsnXHVPZs1CQ8ULAc=";
  };

  pyproject = false;

  propagatedBuildInputs = [
    defusedxml
    python-dateutil
    requests
    xxhash
  ];

  installPhase = ''
    runHook preInstall
    install -D find_posts.py $out/bin/fedifetcher
    runHook postInstall
  '';

  meta = with lib; {
    description = "tool for Mastodon that automatically fetches missing replies and posts from other fediverse instances";
    homepage = "https://blog.thms.uk/fedifetcher";
    license = licenses.mit;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
})
