{ lib
, stdenv
, fetchFromGitHub
, lua
}:

stdenv.mkDerivation rec {
  pname = "haproxy-lua-cors";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "haproxytech";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qXuZtXJDadEXWQZJ8mj1pEcFv/eSqMK4kZ6lmRnGZQ0=";
  };

  nativeCheckInputs = [ lua ];

  installPhase = ''
    runHook preInstall
    install -Dm444 lib/cors.lua $out/share/lua/cors.lua
    runHook postInstall
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    LUA_PATH="$PWD/lib/?.lua;$PWD/tests/?.lua" lua tests/cors_tests.lua
    runHook postCheck
  '';

  meta = {
    description = "Lua library for enabling CORS in HAProxy";
    homepage = "https://github.com/haproxytech/haproxy-lua-cors";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ sbruder ];
  };
}
