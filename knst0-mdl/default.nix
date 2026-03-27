{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule (finalAttrs: {
  pname = "mdl";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "knst0";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-UgTQyt5AGmO3E+8ah6a8+uB/KcjDP7S6BEzTrDWag+E=";
  };

  vendorHash = "sha256-5maXct95GvCfpyV0/XzWL0yqCHATL+CXwwZ8J6rUGSM=";

  subPackages = [ "cmd/cli" ];

  postPatch = ''
    substituteInPlace cmd/cli/main.go \
      --replace 'var version = "1.0.0"' 'var version = "${finalAttrs.version}"'
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 "$GOPATH/bin/cli" $out/bin/mdl
    runHook postInstall
  '';

  meta = with lib; {
    description = "Command line program to download manga from multiple websites";
    homepage = "https://github.com/knst0/mdl";
    license = licenses.mit;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.linux;
  };
})
