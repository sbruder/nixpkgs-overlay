# SPDX-FileCopyrightText: 2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ lib
, stdenv
, fetchzip
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gandhi-fonts";
  version = "unstable-2026-09-12";

  src = fetchzip {
    url = "https://www.tipografiagandhi.com/common/zip/gandhi_sans_and_serif.zip";
    # upstream blocks curl
    curlOptsList = [ "-A" "Mozilla/5.0 (X11; Linux x86_64; rv:154.0) Gecko/20100101 Firefox/154.0" ];
    hash = "sha256-Y2HKqwWzcbjKD2jk5L//EauNxwHMdNKwq411Aon03rs=";
  };

  installPhase = ''
    runHook preInstall

    chmod -x *.otf
    mkdir -p $out/share/fonts/opentype
    mv *.otf $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.tipografiagandhi.com/";
    description = "Gandhi Sans and Gandhi Serif fonts by Librerías Gandhi S.A. de C.V.";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ sbruder ];
    platforms = lib.platforms.all;
  };
})
