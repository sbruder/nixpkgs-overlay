{ lib, stdenv, fetchFromGitHub, fetchpatch, pkg-config, which, curl, gettext, libxml2, ncurses, openssl }:

stdenv.mkDerivation rec {
  pname = "snownews";
  version = "unstable-2021-06-04";

  src = fetchFromGitHub {
    owner = "msharov";
    repo = pname;
    rev = "f0834270dfd54cd6075a603c55e92a490c7d0ace";
    sha256 = "1rqnj6079dhzwlav5physk1h6pxnhbax2bzg3dcp8sr2b7wdzwcz";
  };

  patches = [
    (fetchpatch {
      name = "0001-Encode-feed-title-and-url-for-urls.opml.patch";
      url = "https://github.com/sbruder/snownews/commit/01b291ebd04c67f557b7bf8233fa43f5cda55294.patch";
      sha256 = "0q8b2amidndd2yyhdxhqxm4an2f6yc3aacsf84krbfr4nr37fqck";
    })
  ];

  nativeBuildInputs = [ pkg-config which ];
  buildInputs = [ curl gettext libxml2 ncurses openssl ];

  meta = with lib; {
    description = "A text-mode RSS feed reader";
    homepage = "https://github.com/msharov/snownews";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.unix;
  };
}
