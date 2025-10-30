{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [];

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
  ];

  users.users.steam = {
    isNormalUser = true;
    description = "Steam Gaming User";
    home = "/home/steam";
    createHome = true;
    extraGroups = ["audio" "video"];
    shell = pkgs.bash;
    uid = 1001;
    group = "steam";
  };
  users.groups.steam = {};

  # services.getty.autologinUser = "steam";
  environment.loginShellInit = let
    gs = pkgs.writeShellApplication {
      name = "gs.sh";
      runtimeInputs = [pkgs.gamescope pkgs.steam pkgs.mangohud];
      text = ''
        set -xeuo pipefail

        gamescopeArgs=(
            -w 1980 -h 1080 -W 1980 -H 1080 -r 120
            --expose-wayland
            --adaptive-sync # VRR support
            --hdr-enabled
            --rt
            --steam
        )
        steamArgs=(
            -pipewire-dmabuf
            -tenfoot
        )
        mangoConfig=(
            cpu_temp
            gpu_temp
            ram
            vram
        )
        mangoVars=(
            MANGOHUD=1
            MANGOHUD_CONFIG="$(IFS=,; echo "''${mangoConfig[*]}")"
        )

        export "''${mangoVars[@]}"
        exec ${lib.getExe config.programs.gamescope.package} "''${gamescopeArgs[@]}" -- steam "''${steamArgs[@]}"
      '';
    };
  in ''
    [[ "$(tty)" = "/dev/tty1" ]] && echo "To attempt to start gamescope, run: " && echo ${lib.getExe gs}
  '';
}
