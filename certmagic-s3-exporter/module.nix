# SPDX-FileCopyrightText: 2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ config, lib, pkgs, ... }:
let
  cfg = config.services.certmagic-s3-exporter;
in
{
  options.services.certmagic-s3-exporter = {
    enable = lib.mkEnableOption "Exporter for certificates from certmagic-s3 bucket";
    package = lib.mkPackageOption pkgs "certmagic-s3-exporter" { };
    caddyfilePath = lib.mkOption {
      type = lib.types.path;
      default = config.services.caddy.configFile;
      description = "Caddyfile to load the configuration from";
    };
    certs = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          reloadUnits = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "Which services to reload on file update";
          };
        };
      });
      default = { };
      description = "Attribute set of certificate names to export";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.timers.certmagic-s3-exporter = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "hourly";
        RandomizedDelaySec = "5min";
      };
    };

    systemd.services = lib.mkMerge ([
      {
        certmagic-s3-exporter = {
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          environment = {
            CADDYFILE_PATH = cfg.caddyfilePath;
            CERTS = lib.concatStringsSep " " (lib.attrNames cfg.certs);
            TARGET_DIRECTORY = "%S/certmagic-s3-exporter";
          };
          serviceConfig = {
            Type = "oneshot";
            ExecStart = lib.getExe cfg.package;

            StateDirectory = "certmagic-s3-exporter";
            StateDirectoryMode = "0700";

            # required to access secrets from config
            User = "caddy";
            Group = "caddy";

            CapabilityBoundingSet = null;
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
            RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
            UMask = "0077";
          };
        };
      }
      (lib.mapAttrs'
        (certName: certConfig: lib.nameValuePair "certmagic-s3-exporter-${certName}" {
          after = certConfig.reloadUnits;
          script = ''
            set -euo pipefail
            set -x
            # debounce
            sleep 2
            ${lib.concatMapStringsSep "\n" (service: "systemctl reload ${service}") certConfig.reloadUnits}
          '';
          path = [
            config.systemd.package
          ];
        })
        cfg.certs)
    ] ++ (lib.mapAttrsToList
      (certName: certConfig:
        (lib.listToAttrs
          (map
            (service: lib.nameValuePair service {
              after = lib.singleton "certmagic-s3-exporter-${certName}.service";
              wants = lib.singleton "certmagic-s3-exporter-${certName}.service";
            })
            certConfig.reloadUnits)))
      cfg.certs));

    systemd.paths = lib.mapAttrs'
      (certName: certConfig: lib.nameValuePair "certmagic-s3-exporter-${certName}" {
        wantedBy = [ "paths.target" ];
        after = [ "certmagic-s3-exporter.timer" ];
        wants = [ "certmagic-s3-exporter.timer" ];
        pathConfig.PathChanged = [
          "/var/lib/certmagic-s3-exporter/${certName}.crt"
          "/var/lib/certmagic-s3-exporter/${certName}.key"
        ];
      })
      cfg.certs;
  };
}

