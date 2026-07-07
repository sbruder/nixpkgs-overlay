# SPDX-FileCopyrightText: 2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ config, lib, pkgs, ... }:
let
  cfg = config.services.network-journal;

  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "config.yaml" cfg.settings;
in
{
  options.services.network-journal = {
    enable = lib.mkEnableOption "a collector for network reports that prints them to stdout";
    package = lib.mkPackageOption pkgs "network-journal" { };
    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options = {
          listen = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
          };
          port = lib.mkOption {
            type = lib.types.port;
            default = 8080;
          };

          imap = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = false;
            };
            host = lib.mkOption {
              type = lib.types.str;
              default = "127.0.0.1";
            };
            port = lib.mkOption {
              type = lib.types.port;
              default = 993;
            };
            username = lib.mkOption {
              type = lib.types.str;
              default = "";
            };
            password = lib.mkOption {
              type = lib.types.str;
              default = "";
            };
          };

          filter = {
            domain_whitelist = lib.mkOption {
              type = lib.types.listOf
                (lib.types.either
                  lib.types.str
                  (lib.types.submodule {
                    options = {
                      domain = lib.mkOption {
                        type = lib.types.str;
                      };
                      include_subdomains = lib.mkOption {
                        type = lib.types.bool;
                        default = false;
                      };
                    };
                  }));
            };
          };

          certificate_check = {
            domains = lib.mkOption {
              type = lib.types.listOf (lib.types.submodule {
                options = {
                  domain = lib.mkOption {
                    type = lib.types.str;
                  };
                  port = lib.mkOption {
                    type = lib.types.port;
                  };
                };
              });
              default = [ ];
            };
          };
        };
      };
      default = { };
      description = "Settings to write into network-journal’s configuration file.";
    };
    logLevel = lib.mkOption {
      type = lib.types.enum [ "error" "warn" "info" "debug" "trace" "off" ];
      default = "debug";
      description = "Log level of network-journal.";
    };
    output = lib.mkOption {
      type = lib.types.str;
      default = "journal";
      example = "append:/var/log/network-journal/network-journal.log";
      description = "Where network-journal’s output should be written to. See systemd.exec(5)’s StandardOutput= option for possible values.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.network-journal = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = {
        RUST_LOG = cfg.logLevel;
      };

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/network-journal --config ${configFile}";
        Restart = "always";
        RestartSec = 5;
        StandardOutput = cfg.output;

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
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@privileged" ];
        UMask = "027";
      };
    };
  };
}
