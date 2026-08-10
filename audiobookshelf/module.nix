# SPDX-FileCopyrightText: 2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ config, lib, pkgs, ... }:
let
  cfg = config.services.audiobookshelf;
in
{
  disabledModules = [ "services/web-apps/audiobookshelf.nix" ];

  options = {
    services.audiobookshelf = {
      enable = lib.mkEnableOption "Audiobookshelf";
      package = lib.mkPackageOption pkgs "audiobookshelf" { };
      environment = lib.mkOption {
        type = lib.types.submodule {
          freeformType = lib.types.attrsOf lib.types.str;

          options = {
            HOST = lib.mkOption {
              description = "The host audiobookshelf should listen on";
              default = "127.0.0.1";
              type = lib.types.str;
            };
            PORT = lib.mkOption {
              description = "The port audiobookshelf should listen on";
              default = "3333";
              type = lib.types.str;
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.audiobookshelf = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      inherit (cfg) environment;

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package}";
        DynamicUser = true;
        StateDirectory = "audiobookshelf";
        WorkingDirectory = "%S/audiobookshelf";

        CapabilityBoundingSet = null;
        DeviceAllow = null;
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
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
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@resources" "~@privileged" "@chown" ];
      };
    };
  };
}
