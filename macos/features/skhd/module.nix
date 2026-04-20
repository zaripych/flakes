{
  lib,
  username,
  pkgs,
  ...
}: {
  services.skhd = let
    scripts = pkgs.callPackage ./scripts.nix {};
    skhd-zig = pkgs.callPackage ./skhd-zig-precompiled.nix {};
    run-script = "${scripts}/bin/skhd-scripts";
  in {
    enable = true;
    package = skhd-zig;
    skhdConfig = ''
      # For documentation: https://github.com/jackielii/skhd.zig

      .load "/Users/${username}/.skhdrc"

      # STARTING AND RESTARTING APPS/SERVICES

      # -- restart yabai --
      cmd + alt + ctrl - y : launchctl kickstart -k "gui/''${UID}/org.nixos.yabai"

      # -- restart skhd --
      cmd + alt + ctrl - s : launchctl kickstart -k "gui/''${UID}/org.nixos.skhd"

      # -- refresh config
      cmd + alt + ctrl - r : yabai -m window --toggle system-refresh-terminal || { \
        open -n -a /etc/profiles/per-user/${username}/bin/kitty --args -1 --working-directory="$HOME" --hold system-refresh switch \
      }

      # -- toggling scratchpads
      cmd + ctrl - t : yabai -m window --toggle terminal || { \
        open -n -a /etc/profiles/per-user/${username}/bin/kitty --args -1 -T scratch-terminal --instance-group=scratch-terminal --working-directory="$HOME" \
      }

      # SPACES AND WINDOWS NAVIGATION

      # -- focusing within the current "space" --
      cmd + ctrl - left  : ${run-script} "focusLeft()"
      cmd + ctrl - down  : yabai -m window --focus south
      cmd + ctrl - up    : yabai -m window --focus north
      cmd + ctrl - right : ${run-script} "focusRight()"

      # -- focusing spaces --
      cmd + ctrl - 1 : yabai -m space --focus 1
      cmd + ctrl - 2 : yabai -m space --focus 2
      cmd + ctrl - 3 : yabai -m space --focus 3
      cmd + ctrl - 4 : yabai -m space --focus 4
      cmd + ctrl - 5 : yabai -m space --focus 5
      cmd + ctrl - 6 : yabai -m space --focus 6
      cmd + ctrl - 7 : yabai -m space --focus 7
      cmd + ctrl - 8 : yabai -m space --focus 8

      # -- moving to another "space" on the current display --
      cmd + ctrl + shift - left : yabai -m window --space prev --focus
      cmd + ctrl + shift - right : yabai -m window --space next --focus

      cmd + ctrl + shift - 1 : yabai -m window --space 1 --focus
      cmd + ctrl + shift - 2 : yabai -m window --space 2 --focus
      cmd + ctrl + shift - 3 : yabai -m window --space 3 --focus
      cmd + ctrl + shift - 4 : yabai -m window --space 4 --focus
      cmd + ctrl + shift - 5 : yabai -m window --space 5 --focus
      cmd + ctrl + shift - 6 : yabai -m window --space 6 --focus
      cmd + ctrl + shift - 7 : yabai -m window --space 7 --focus
      cmd + ctrl + shift - 8 : yabai -m window --space 8 --focus

      # -- moving to another to another display --
      cmd + alt + ctrl - 1 : yabai -m window --display 1; yabai -m display --focus 1
      cmd + alt + ctrl - 2 : yabai -m window --display 2; yabai -m display --focus 2
      cmd + alt + ctrl - 3 : yabai -m window --display 3; yabai -m display --focus 3

      # -- focus another display --
      cmd + alt + ctrl - left  : yabai -m display --focus prev || yabai -m display --focus recent
      cmd + alt + ctrl - right : yabai -m display --focus next || yabai -m display --focus recent

      # WINDOW POSITIONING AND SIZING

      # -- swapping windows within the current "space" --
      cmd + alt - r : yabai -m space --mirror y-axis
      cmd + alt + shift - r : yabai -m space --rotate 90
      cmd + alt - e : yabai -m window --toggle split

      # -- resizing --
      cmd + alt - 0 : yabai -m space --balance
      cmd + alt - f : yabai -m window --toggle zoom-fullscreen
      cmd + alt + shift - f  : yabai -m window --toggle zoom-parent

      # uses brackets left: [ right: ]
      cmd + alt - 0x21 : yabai -m window --resize left:-20:0
      cmd + alt + shift - 0x21 : yabai -m window --resize left:20:0
      cmd + alt - 0x1E : yabai -m window --resize right:20:0
      cmd + alt + shift - 0x1E : yabai -m window --resize right:-20:0

      # uses + and -
      cmd + alt - 0x1B : yabai -m window --resize top:0:20
      cmd + alt + shift - 0x1B : yabai -m window --resize top:0:-20
      cmd + alt - 0x18 : yabai -m window --resize bottom:0:20
      cmd + alt + shift - 0x18 : yabai -m window --resize bottom:0:-20

      # -- floating windows --
      cmd + alt + ctrl - f : yabai -m window --toggle float; \
                             yabai -m window --grid 4:4:1:1:2:2
    '';
  };
}
