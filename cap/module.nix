{ config, lib, pkgs, ... }:
let
  cfg = config.services.cap;
in
{
  options.services.cap = {
    enable = lib.mkEnableOption "the privacy-first, self-hosted CAPTCHA for the modern web";
    package = lib.mkPackageOption pkgs "cap" { };
    environment = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf lib.types.str;

        options = {
          SERVER_PORT = lib.mkOption {
            type = lib.types.str;
            default = "3000";
            description = "The port cap should listen on";
          };
          SERVER_HOSTNAME = lib.mkOption {
            type = lib.types.str;
            default = "0.0.0.0";
            description = "The host cap should listen on";
          };
          VALKEY_URL = lib.mkOption {
            type = lib.types.str;
            default = "redis://${config.services.redis.servers.cap.bind}:${toString config.services.redis.servers.cap.port}";
            description = "The connection string for connecting to valkey";
          };
        };
      };
      default = { };
      description = "Environment variables to pass to cap";
    };
    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "/run/secrets/cap.env";
      description = ''
        A file including environment variables being passed to cap to allow storing secrets outside of the nix store.
        It should be formatted according to the specification of systemd.exec(5)’s EnvironmentFile.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.cap = {
      wantedBy = [ "multi-user.target" ];
      requires = [ "redis-cap.service" ];
      after = [ "network.target" "redis-cap.service" ];

      inherit (cfg) environment;

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/cap";
        Restart = "always";

        EnvironmentFile = cfg.environmentFile;

        # systemd-analyze --no-pager security cap.service
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
        SystemCallFilter = [ "@system-service" "~@privileged" ];
        UMask = "777";
      };
    };

    services.redis.servers.cap = {
      enable = true;
      port = lib.mkDefault 6379;
    };
  };
}
