{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "haproxy-lua-http";
  version = "unstable-2021-07-05";

  src = fetchFromGitHub {
    owner = "haproxytech";
    repo = pname;
    rev = "670d0d278182902f252faffc17eeb51a7ecb4b9d";
    hash = "sha256-ooHq9ORqJcu4EPFVOMtyPC5uk05adkysfm2VhiAJUtY=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm444 http.lua $out/share/lua/${pname}/http.lua
    runHook postInstall
  '';

  meta = {
    description = "Simple Lua HTTP helper and client for use with HAProxy";
    homepage = "https://github.com/haproxytech/haproxy-lua-http";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ sbruder ];
  };
}
