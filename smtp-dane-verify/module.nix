# SPDX-FileCopyrightText: 2026 Simon Bruder <simon@sbruder.de>
#
# SPDX-License-Identifier: MIT OR Apache-2.0

{ config, lib, pkgs, ... }:
let
  cfg = config.services.smtp-dane-verify;
in
{
  options.services.smtp-dane-verify = {
    enable = lib.mkEnableOption "a service that let’s you monitor and detect typical DANE related problems for DANE-enabled inbound SMTP services.";
    package = lib.mkPackageOption pkgs "smtp-dane-verify" { };
    listen = {
      address = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "The address to listen on.";
      };
      port = lib.mkOption {
        type = lib.types.port;
        default = 3000;
        description = "The port to bind to.";
      };
    };
    apiKey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "The api key for the service. Will be stored in the world-readable nix store!";
    };
    nameserver = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Which DNSSEC-enabled nameserver to used for resolving the TLSA records.";
    };
    metricsDomains = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Which domains to check periodically for exporting metrics.";
    };
    metricsInterval = lib.mkOption {
      type = lib.types.int;
      default = 60;
      description = "The interval at which the metrics domains are checked.";
    };
    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "File to load additional environment variables from.";
    };
    logLevel = lib.mkOption {
      type = lib.types.str;
      default = "warning";
      description = "The log level for unicorn to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.smtp-dane-verify = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];

      environment = {
        APIKEY = cfg.apiKey;
        NAMESERVER = cfg.nameserver;
        METRICS_DOMAINS = lib.concatStringsSep "," cfg.metricsDomains;
        METRICS_INTERVAL = toString cfg.metricsInterval;
      };

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/smtp-dane-verify --address ${lib.escapeShellArg cfg.listen.address} --port ${toString cfg.listen.port} --log-level ${lib.escapeShellArg cfg.logLevel}";

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
        UMask = "777";
      };
    };
  };
}

