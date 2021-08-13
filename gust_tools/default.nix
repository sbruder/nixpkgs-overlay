{ lib, stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "gust_tools";
  version = "1.37";

  src = fetchFromGitHub {
    owner = "VitaSmith";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/Uq+NaAAKbiEAxFnB0UJkhdsGKa6uQBnH9AmAlpi30s=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/VitaSmith/gust_tools/commit/b564b54b1825e15bc743450605d8dae0a7366d1e.patch";
      sha256 = "sha256-geTqFT89U2JRJwKduqkRbO0DlOvKxqqquvVVVIu2IB8=";
    })
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp gust_{ebm,elixir,enc,g1t,pak} $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    description = "A set of utilities for dealing with Gust (Koei Tecmo) PC games files";
    homepage = "https://github.com/VitaSmith/gust_tools";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.unix;
  };
}
