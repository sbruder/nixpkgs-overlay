{ pkgs }:
self: super: {

  bandcamp-downloader = super.bandcamp-downloader.overridePythonAttrs (
    _: {
      src = pkgs.fetchgit {
        url = "https://github.com/easlice/bandcamp-downloader";
        rev = "f6f4828c286821b006045fa8b85a55e90bfdb376";
        sha256 = "0dwchw1rz29dir2saag06gf0259fih1crdvb8qjbkywwiflh63bf";
      };
    }
  );

}
