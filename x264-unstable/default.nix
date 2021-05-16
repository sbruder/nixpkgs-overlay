{ lib, fetchFromGitLab }:

o: o // rec {
  version = "unstable-2021-04-19";

  src = fetchFromGitLab {
    domain = "code.videolan.org";
    owner = "videolan";
    repo = o.pname;
    rev = "b684ebe04a6f80f8207a57940a1fa00e25274f81";
    sha256 = "06r6m1v88m532wbhk6al9imrsn1inwdjzrpmp97wrbdg6b2naygd";
  };

  meta = with lib; o.meta // {
    description = "${o.meta.description} (unstable version)";
    maintainers = with maintainers; [ sbruder ];
  };
}
