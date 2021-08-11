{ lib, stdenv, fetchFromGitHub }:

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
    ./0001-gust_ebm-fix-compiler-error-about-different-signs.patch
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
