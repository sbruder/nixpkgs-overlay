{ lib, buildLuarocksPackage, fetchFromGitHub, fetchurl, lpeg, luaOlder }:

buildLuarocksPackage {
  pname = "luajson";
  version = "1.3.4-1";

  knownRockspec = (fetchurl {
    url = "mirror://luarocks/luajson-1.3.4-1.rockspec";
    sha256 = "1zcj3bv7k7qh6f9fh4fsard0aydb84yg3mr070kf6s4hmryj0bpr";
  }).outPath;

  src = fetchFromGitHub {
    owner = "harningt";
    repo = "luajson";
    rev = "1.3.4";
    hash = "sha256-JaJsjN5Gp+8qswfzl5XbHRQMfaCAJpWDWj9DYWJ0gEI=";
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
