{ config, lib, options, pkgs, ... }:
let
  cfg = config.services.hcloud_exporter;
in
{
  options.services.hcloud_exporter = {
    enable = lib.mkEnableOption "the prometheus hcloud exporter";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.hcloud_exporter;
      description = "The package to use for hcloud_exporter";
    };
    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0:9501";
      example = "127.0.0.1:9501";
      description = "The address hcloud_exporter should listen on";
    };
    collectors = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "floating-ips" "images" "pricing" "servers" "ssh-keys" ];
      example = [ "servers" "volumes" ];
      description = "The collectors to enable";
    };
    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "/path/to/hcloud_exporter.env";
      description = ''
        A file including environment variables being passed to hcloud_exporter
        to allow storing the token outside of the nix store.
        It should be formatted according to the specification of systemd.exec(5)’s EnvironmentFile.
      '';
    };
  };

  config = {
    systemd.services.hcloud_exporter = lib.mkIf cfg.enable {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        HCLOUD_EXPORTER_WEB_ADDRESS = cfg.listenAddress;
      } // (
        let
          defaultCollectors = options.services.hcloud_exporter.collectors.default;
          enabledCollectors = cfg.collectors;
          disabledCollectors = lib.subtractLists enabledCollectors defaultCollectors;
          collectorAttrs = lib.listToAttrs
            (map (lib.flip lib.nameValuePair "true") enabledCollectors
              ++ map (lib.flip lib.nameValuePair "false") disabledCollectors);
          toUpperSnakeCase = x: lib.toUpper (lib.replaceStrings [ "-" ] [ "_" ] x);
          collectorStateToEnv = collector: state: lib.nameValuePair "HCLOUD_EXPORTER_COLLECTOR_${toUpperSnakeCase collector}" state;
        in
        lib.mapAttrs' collectorStateToEnv collectorAttrs
      );
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/hcloud_exporter";
        Restart = "always";

        EnvironmentFile = cfg.environmentFile;

        # systemd-analyze --no-pager security hcloud_exporter.service
        CapabilityBoundingSet = null;
        DynamicUser = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectHome = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service";
      };
    };
  };
}
