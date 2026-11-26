# SPDX-FileCopyrightText: 2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ lib, stdenv, fetchgit, meson, ninja, pkg-config, glib, libev }:

stdenv.mkDerivation (finalAttrs: {
  pname = "fcgi-cgi";
  version = "0.2.3";

  src = fetchgit {
    # gitea instance blocks all requests except for viewing of main page and git clones
    url = "https://git.lighttpd.net/lighttpd/${finalAttrs.pname}.git";
    tag = "fcgi-cgi-${finalAttrs.version}";
    hash = "sha256-Mc3IvoOAqoRoWzw4ZWdmvSdz4VDwcoxYnqDdTQymskU=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ glib libev ];

  meta = with lib; {
    description = "FastCGI application to run cgi applications";
    homepage = "https://git.lighttpd.net/lighttpd/fcgi-cgi";
    license = licenses.mit;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.linux;
  };
})
