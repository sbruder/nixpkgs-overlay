# SPDX-FileCopyrightText: 2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ lib, cef-binary, rustPlatform, fetchFromGitHub, llvmPackages, makeWrapper, pkg-config, libxcb, libxkbcommon, ffmpeg, mpv, stdenv }:
let
  cef = (cef-binary.override {
    # keep in sync with version of cef-dll-sys (after the +)
    # The correct values can be found by searching for the version on https://cef-builds.spotifycdn.com/index.html#linux64
    version = "151.3.16";
    gitRevision = "be1e15d";
    chromiumVersion = "151.0.7922.109";

    srcHashes = {
      x86_64-linux = "sha256-6usxPmA53kZIVYk9KHxNXrTscSaXjqg8YWS/SiPcAXo=";
    };
  });
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jellium-desktop";
  version = "unstable-2026-08-10";

  src = fetchFromGitHub {
    owner = "andrewrabert";
    repo = finalAttrs.pname;
    rev = "28f2cf16a1f1b819884dd6a72919ca55bdf9bd73";
    hash = "sha256-fMk5bZRMi6FgTGigu3/fYX9sj1HmKW5mp+Ipc+BO+tQ=";
  };

  sourceRoot = "source/src";

  cargoHash = "sha256-JFFQjOw4Iu6NiQScQqYg/J7XEkLbHCDa+XS12VJJdVI=";

  postPatch = ''
    substituteInPlace $cargoDepsCopy/*/cef-dll-sys-*/build.rs \
      --replace-fail 'download_cef::check_archive_json(&package_version, &path.to_string_lossy())?;' ""
  '';

  nativeBuildInputs = [
    llvmPackages.clang # required for bindgen
    makeWrapper
    pkg-config
  ];
  buildInputs = [
    cef
    ffmpeg
    libxcb
    libxkbcommon
    mpv
  ];

  env = {
    LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  };

  preConfigure = ''
    # needs to be writable
    cp -r --no-preserve=mode ${cef} cef-path
    # and in a non-default format
    mv cef-path/{Release,Resources}/* cef-path
    rmdir cef-path/{Release,Resources}
    export CEF_PATH=$(realpath cef-path)
  '';

  installPhase = ''
    runHook preInstall

    find target

    mkdir -p $out/share/${finalAttrs.pname}
    mv target/${stdenv.targetPlatform.rust.cargoShortTarget}/$cargoBuildType/${finalAttrs.pname} $out/share/${finalAttrs.pname}
    cp -r ${cef}/{Release,Resources}/* $out/share/${finalAttrs.pname}

    makeWrapper $out/share/${finalAttrs.pname}/${finalAttrs.pname} $out/bin/${finalAttrs.pname}

    runHook postInstall
  '';

  meta = {
    description = "An unofficial desktop client for Jellyfin";
    homepage = "https://github.com/andrewrabert/jellium-desktop";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ sbruder ];
    platforms = lib.platforms.linux;
  };
})
