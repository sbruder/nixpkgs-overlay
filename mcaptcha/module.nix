{ config, lib, pkgs, ... }:
let
  cfg = config.services.mcaptcha;

  settingsFormat = pkgs.formats.toml { };
  defaultConfig = (builtins.fromTOML (builtins.readFile "${cfg.package}/share/mcaptcha/config.toml"));
  configFile = settingsFormat.generate "config.toml" (lib.recursiveUpdate defaultConfig cfg.settings);
in
{
  options.services.mcaptcha = {
    enable = lib.mkEnableOption "A no-nonsense CAPTCHA system with seamless UX";
    package = lib.mkPackageOption pkgs "mcaptcha" { };
    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options = {
          debug = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          allow_demo = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          allow_registration = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };

          server = {
            port = lib.mkOption {
              type = lib.types.port;
              default = 7000;
            };
            ip = lib.mkOption {
              type = lib.types.str;
              default = "127.0.0.1";
            };
            domain = lib.mkOption {
              type = lib.types.str;
            };
            proxy_has_tls = lib.mkOption {
              type = lib.types.bool;
              default = true;
            };
          };

          #captcha = {
          #  gc = lib.mkOption {
          #    type = lib.types.int;
          #    default = 30;
          #  };
          #  runners = lib.mkOption {
          #    type = lib.types.int;
          #    default = 4;
          #  };
          #  queue_length = lib.mkOption {
          #    type = lib.types.int;
          #    default = 2000;
          #  };
          #  enable_stats = true
          #};

          database.url = lib.mkOption {
            type = lib.types.str;
            default = "postgres:///mcaptcha";
          };

          redis.url = lib.mkOption {
            type = lib.types.str;
            default = "redis://${config.services.redis.servers.mcaptcha.bind}:${toString config.services.redis.servers.mcaptcha.port}";
          };
        };
      };
      default = { };
      description = "Settings to write into mcaptcha’s configuration file. It is merged with the default configuration.";
    };
    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "/run/secrets/mcaptcha.env";
      description = ''
        A file including environment variables being passed to mcaptcha to allow storing secrets outside of the nix store.
        It should be formatted according to the specification of systemd.exec(5)’s EnvironmentFile.
      '';
    };
    logLevel = lib.mkOption {
      type = lib.types.enum [ "error" "warn" "info" "debug" "trace" "off" ];
      default = "warn";
      description = "Log level of mcaptcha to systemd journal";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.mcaptcha = {
      wantedBy = [ "multi-user.target" ];
      requires = [ "postgresql.target" "redis-mcaptcha.service" ];
      after = [ "network.target" "postgresql.target" "redis-mcaptcha.service" ];

      environment = {
        MCAPTCHA_CONFIG = configFile;
        RUST_LOG = cfg.logLevel;
      };

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/mcaptcha";
        # adapted from upstream documentation (https://mcaptcha.org/docs/self-hosting/bare-metal)
        Restart = "on-failure";
        RestartSec = 1;
        SuccessExitStatus = [ 3 4 ];
        RestartForceExitStatus = [ 3 4 ];

        EnvironmentFile = cfg.environmentFile;

        # systemd-analyze --no-pager security mcaptcha.service
        CapabilityBoundingSet = null;
        DynamicUser = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
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
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@privileged" ];
        UMask = "777";
      };
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "mcaptcha" ];
      ensureUsers = lib.singleton {
        name = "mcaptcha";
        ensureDBOwnership = true;
      };
    };

    services.redis.servers.mcaptcha = {
      enable = true;
      port = lib.mkDefault 6379;
      settings = {
        loadmodule = [ "${pkgs.mcaptcha-cache}/lib/libcache.so" ];
      };
    };
  };
}
