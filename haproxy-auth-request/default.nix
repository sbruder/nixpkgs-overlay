{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "haproxy-auth-request";
  version = "unstable-2026-02-20";

  src = fetchFromGitHub {
    owner = "TimWolla";
    repo = pname;
    rev = "cdb891cf52995780bb6128c2a7495d36325e4ff2";
    hash = "sha256-1JibFpzfDljK8gMJUilQaWHuxQ0hRvQesu8wCB4MbCI=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm444 auth-request.lua $out/share/lua/auth-request.lua
    runHook postInstall
  '';

  meta = {
    description = "auth-request allows you to add access control to your HTTP services based on a subrequest to a configured HAProxy backend";
    homepage = "https://github.com/TimWolla/haproxy-auth-request";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ sbruder ];
  };
}
