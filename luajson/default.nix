{ lib, buildLuarocksPackage, fetchFromGitHub, fetchurl, lpeg, luaOlder }:

buildLuarocksPackage {
  pname = "luajson";
  version = "unstable-2023-10-10";

  knownRockspec = (fetchurl {
    url = "mirror://luarocks/luajson-1.3.4-1.rockspec";
    sha256 = "1zcj3bv7k7qh6f9fh4fsard0aydb84yg3mr070kf6s4hmryj0bpr";
  }).outPath;

  src = fetchFromGitHub {
    owner = "harningt";
    repo = "luajson";
    rev = "6ecaf9bea8b121a9ffca5a470a2080298557b55d";
    hash = "sha256-56G0NqIpavKHMQWUxy+Bp7G4ZKrQwUZ2C5e7GJxUJeg=";
  };

  disabled = luaOlder "5.1";
  propagatedBuildInputs = [ lpeg ];

  meta = with lib; {
    description = "customizable JSON decoder/encoder";
    homepage = "https://www.eharning.us/wiki/luajson/";
    license = licenses.mit;
    maintainers = with maintainers; [ sbruder ];
  };
}
