# SPDX-FileCopyrightText: 2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, cryptography
, dnspython
, fastapi
, pydantic
, uvicorn
, openssl
}:

buildPythonPackage rec {
  pname = "smtp_dane_verify";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gOS83m1284r536GZ4FVM5KX9wJCSAjXZA+gpM8Co22g=";
  };

  pyproject = true;
  build-system = [ hatchling ];

  dependencies = [
    cryptography
    dnspython
    fastapi
    pydantic
    uvicorn

    (lib.getBin openssl)
  ];

  postInstall = ''
    install -D ${./server.py} $out/bin/smtp-dane-verify
  '';

  checkPhase = ''
    runHook preCheck

    $out/bin/smtp-dane-verify --help

    runHook postCheck
  '';

  meta = with lib; {
    description = "A service that let’s you monitor and detect typical DANE related problems for DANE-enabled inbound SMTP services.";
    homepage = "https://github.com/sys4/smtp-dane-verify";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.all;
  };
}
