{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, async-lru
, click
, colorama
, dataclass-click
, httpx
, httpx-retries
, inquirerpy
, m3u8
, mutagen
, pillow
, pywidevine
, structlog
, yt-dlp
, bento4
, ffmpeg
, gpac
, n-m3u8dl-re
}:

buildPythonPackage rec {
  pname = "gamdl";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "glomatico";
    repo = pname;
    rev = version;
    sha256 = "sha256-7Dt1aRBDB6hkztorH5FyN5IXoKlBXWTNyj1scKARgEs=";
  };

  pyproject = true;
  build-system = [ setuptools ];

  propagatedBuildInputs = [
    async-lru
    click
    colorama
    dataclass-click
    httpx
    httpx-retries
    inquirerpy
    m3u8
    mutagen
    pillow
    pywidevine
    structlog
    yt-dlp

    # external dependencies
    bento4 # mp4decrypt
    ffmpeg
    gpac # mp4box
    n-m3u8dl-re
  ];

  meta = with lib; {
    description = "command-line app for downloading Apple Music songs, music videos and post videos";
    homepage = "https://github.com/glomatico/gamdl";
    license = licenses.mit;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.linux;
  };
}
