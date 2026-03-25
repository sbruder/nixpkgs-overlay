{ config, lib, pkgs, ... }:
let
  cfg = config.services.komf;

  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "application.yml" cfg.settings;
in
{
  options.services.komf = {
    enable = lib.mkEnableOption "Komga and Kavita metadata fetcher";
    package = lib.mkPackageOption pkgs "komf" { };
    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
      };
      description = ''
        Komf configuration.

        See [Komf’s README](https://github.com/Snd-R/komf/tree/master?tab=readme-ov-file#example-applicationyml-config) for an example.
      '';
    };
    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "/run/secrets/komf.env";
      description = ''
        A file including environment variables being passed to komf to allow storing secrets outside of the nix store.
        It should be formatted according to the specification of systemd.exec(5)’s EnvironmentFile.
      '';
    };
  };

  config = {
    systemd.services.komf = lib.mkIf cfg.enable {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/komf ${configFile}";
        Restart = "always";

        StateDirectory = "komf";
        WorkingDirectory = "/var/lib/komf";

        EnvironmentFile = cfg.environmentFile;

        # systemd-analyze --no-pager security komf.service
        CapabilityBoundingSet = null;
        DynamicUser = true;
        LockPersonality = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "noaccess";
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
        UMask = "027";
      };
    };
  };
}
