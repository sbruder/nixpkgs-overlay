{ pkgs }:
self: super: {

  bandcamp-downloader = super.bandcamp-downloader.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/easlice/bandcamp-downloader";
        rev = "fbf860a3b06af0e02f3c58531b9683f934c23db5";
        sha256 = "19by94ag1rj02amna1lg9v9qzanf4l606caskxr77092hplkpps3";
      };
    }
  );

}
