{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, freetype, zlib }:

stdenv.mkDerivation (finalAttrs: {
  pname = "tsMuxer";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "justdan96";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-EsAXCqwkAdAvuiM3p0lU2tTwS7hN7sTINFdaVRdAwXQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    freetype
    zlib
  ];

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  meta = with lib; {
    description = "transport stream muxer for remuxing/muxing elementary streams";
    homepage = "https://github.com/justdan96/tsMuxer";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.unix;
  };
})
