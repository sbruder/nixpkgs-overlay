{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "whisper.cpp";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "ggerganov";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7/10t1yE7Gbs+cyj8I9vJoDeaxEz9Azc2j3f6QCjDGM=";
  };

  postPatch = ''
    substituteInPlace models/download-ggml-model.sh \
        --replace 'models_path="$(get_script_path)"' 'models_path="$HOME/.local/share/whisper_cpp"'
  '';

  installPhase = ''
    runHook preInstall
    install -D main $out/bin/${pname}
    install -D models/download-ggml-model.sh $out/bin/download-ggml-model
    runHook postInstall
  '';

  meta = with lib; {
    description = "Port of OpenAI's Whisper model in C/C++";
    homepage = "https://github.com/ggerganov/whisper.cpp/";
    license = licenses.mit;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.unix;
  };
}
