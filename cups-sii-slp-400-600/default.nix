{ stdenv
, lib
, fetchzip
, fetchpatch
, cups
, perl
}:

stdenv.mkDerivation {
  pname = "cups-sii-slp-400-600";
  version = "unstable-2021-12-09"; # Last-Modified HTTP header of zip file

  src = fetchzip {
    url = "https://siibusinessproducts.com/wp-content/uploads/2021/12/SLP-400-600-SeikoSLPLinuxCUPSDriver.zip";
    hash = "sha256-ZBBuZ87zXkeDKS0HP6R0gCHiJHCwGUJZIkWOE9WZxOU=";
  };

  patches = [
    (fetchpatch {
      name = "Fix-includes.patch";
      url = "https://github.com/fawkesley/smart-label-printer-slp-linux-driver/commit/292e4b78b664379230c3a630e456bc5a696bf757.patch";
      hash = "sha256-XHjMHCBbIEAtYUQj7o4y5U4OYzGtnyqxuMYlhfMng9g=";
    })
  ];

  patchFlags = [ "-p2" ];

  nativeBuildInputs = [
    cups.dev
    perl # required to patch paths in PPD files
  ];

  makeFlags = [ "ppddir=$(out)/share/cups/model/seiko" "filterdir=$(out)/lib/cups/filter" ];

  preInstall = ''
    mkdir -p $out/{share/cups/model/seiko,lib/cups/filter}
  '';

  meta = with lib; {
    description = "CUPS Driver (PPD and filter) for Seiko Instruments Inc (SII) SLP100/410, SLP200/420, SLP240/430, SLP440, SLP450, SLP620, SLP650/SLP650SE";
    homepage = "https://siibusinessproducts.com/support/linux-software-and-drivers/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.unix;
  };
}
