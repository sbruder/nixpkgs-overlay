{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-svgbob";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "boozook";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5wfFT/7yc+55fcEi/KvmN1aR+hhUQi+0WdZukeD3xG4=";
  };

  cargoHash = "sha256-jMSwqE4XAz0fG4sG3Cgtj9OhlqwL0N9aGgpRaEtC09Q=";

  meta = {
    description = "SvgBob mdbook preprocessor which swaps code-blocks with SVG";
    homepage = "https://github.com/boozook/mdbook-svgbob";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ sbruder ];
    platforms = lib.platforms.linux;
  };
}
