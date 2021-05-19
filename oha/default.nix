{ lib, rustPlatform, fetchFromGitHub, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "oha";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "hatoo";
    repo = pname;
    rev = "v${version}";
    sha256 = "0grq9qk34i1k1nmw77d0f19qxq5f4hqax7x1pjrqmq972ix194wr";
  };

  cargoSha256 = "14cc4hzg755brmr657mbmiqwbf26sn252vn4cywp0zs6y63mmxfw";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  doCheck = false; # tests require network

  meta = with lib; {
    description = "HTTP load generator, inspired by rakyll/hey with tui animation";
    homepage = "https://github.com/hatoo/oha";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.unix;
  };
}
