{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hcloud_exporter";
  version = "unstable-2021-06-07";

  src = fetchFromGitHub {
    owner = "promhippie";
    repo = pname;
    rev = "f22c52bf79ecafafdecf6a3b6dd3642b51b20ddb";
    sha256 = "sha256-7UJhM/HLhRySTQ1lNLMgfKD9GDOivRMhGGNVLQknMLA=";
  };

  vendorHash = "sha256-qWYj/BCuY/995pLiBUoMtKvDV81j17c2GJeqhgBWn74=";

  meta = with lib; {
    description = "Prometheus exporter for Hetzner Cloud";
    homepage = "https://promhippie.github.io/hcloud_exporter/";
    license = licenses.asl20;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.linux;
  };
}
