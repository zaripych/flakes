{
  pkgs,
  lib,
  username,
  config,
  ...
}: let
  cfg = config.services.aerospace-swipe;
  aerospace-swipe = pkgs.callPackage ./default.nix {};
  socket = "/tmp/bobko.aerospace-${username}.sock";
  configDir = pkgs.runCommand "aerospace-swipe-config" {} ''
    mkdir -p $out
    cp ${pkgs.writeText "config.json" (builtins.toJSON cfg.settings)} $out/config.json
  '';
  launcher = pkgs.writeShellScriptBin "aerospace-swipe" ''
    /bin/wait4path ${socket}
    cd ${configDir}
    exec ${aerospace-swipe}/bin/swipe
  '';
in {
  options.services.aerospace-swipe = {
    enable = lib.mkEnableOption "aerospace-swipe gesture daemon" // {default = true;};

    settings = lib.mkOption {
      type = lib.types.attrsOf (lib.types.oneOf [lib.types.bool lib.types.int lib.types.float]);
      default = {};
      description = ''
        Contents of `./config.json` loaded by swipe at startup. Only the keys
        listed below are read by the parser (see `src/config.h` in
        https://github.com/acsandmann/aerospace-swipe). Swipe direction is
        controlled by `natural_swipe` — `swipe_left`/`swipe_right` keys are
        ignored.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.aerospace-swipe.settings = {
      # Upstream defaults (src/config.h default_config()), pinned here for
      # visibility. Override per-host via services.aerospace-swipe.settings.*
      natural_swipe = lib.mkDefault false;
      wrap_around = lib.mkDefault true;
      haptic = lib.mkDefault false;
      skip_empty = lib.mkDefault true;
      fingers = lib.mkDefault 3;
      swipe_tolerance = lib.mkDefault 0;
      distance_pct = lib.mkDefault 0.08;
      velocity_pct = lib.mkDefault 0.30;
      settle_factor = lib.mkDefault 0.15;
    };

    environment.systemPackages = [aerospace-swipe];

    launchd.user.agents.aerospace-swipe = {
      serviceConfig = {
        Label = "org.nixos.aerospace-swipe";
        ProgramArguments = ["${launcher}/bin/aerospace-swipe"];
        EnvironmentVariables.PATH = "/run/current-system/sw/bin:/usr/bin:/bin:/usr/sbin:/sbin";
        RunAtLoad = true;
        KeepAlive = true;
        LimitLoadToSessionType = "Aqua";
        ProcessType = "Interactive";
        Nice = 0;
        StandardOutPath = "/tmp/swipe.out";
        StandardErrorPath = "/tmp/swipe.err";
      };
    };
  };
}
