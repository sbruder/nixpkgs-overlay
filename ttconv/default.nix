# SPDX-FileCopyrightText: 2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "ttconv";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wFl9wE0QdhkrlBVtvp0efhE9EyOhgC7KoGLM33CwTRY=";
  };

  pyproject = true;
  build-system = [ setuptools ];

  propagatedBuildInputs = [
  ];

  meta = with lib; {
    description = "Subtitle conversion library and CLI tool. Converts between STL, SRT, TTML, SCC, TTML and WebVTT files";
    homepage = "https://github.com/sandflow/ttconv";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.linux;
  };
}
