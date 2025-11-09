{pkgs, ...}: {
  config.services.skhd = let
    deps = pkgs.buildNpmPackage {
      pname = "scripts-builder";
      version = "0.1.0";
      src = ./scripts;

      npmDeps = pkgs.importNpmLock {
        npmRoot = ./scripts;
      };

      npmConfigHook = pkgs.importNpmLock.npmConfigHook;
    };
    runScript = pkgs.writeShellScriptBin "run" ''
      ${pkgs.nodejs}/bin/node --import ${deps}/lib/node_modules/key-remapping-scripts/dist/exportAsGlobals.js -e "$@"
    '';
    run = "${runScript}/bin/run";
  in {
    enable = true;
    skhdConfig = ''
      #############################################################
      # For skhd info see: https://github.com/koekeishiya/skhd
      #############################################################

      # -- restart yabai --
      cmd + alt + ctrl - y : launchctl kickstart -k "gui/''${UID}/org.nixos.yabai"

      # -- restart skhd --
      cmd + alt + ctrl - s : skhd -r

      ###################
      # WINDOW MANAGEMENT
      ###################

      # -- focusing within the current "space" --
      cmd + alt - left  : ${run} "focusLeft()"
      cmd + alt - down  : yabai -m window --focus south
      cmd + alt - up    : yabai -m window --focus north
      cmd + alt - right : ${run} "focusRight()"

      # -- rearraging within the current "space" --
      ## cmd + alt - h : yabai -m window --warp west
      ## cmd + alt - j : yabai -m window --warp south
      ## cmd + alt - k : yabai -m window --warp north
      ## cmd + alt - l : yabai -m window --warp east
      ## cmd + alt - u : yabai -m window --swap west
      ## cmd + alt - i : yabai -m window --swap south
      ## cmd + alt - o : yabai -m window --swap north
      ## cmd + alt - p : yabai -m window --swap east

      cmd + alt - r : yabai -m space --mirror y-axis
      cmd + alt + shift - r : yabai -m space --rotate 90

      # -- change split type of focused window --
      cmd + alt - e : yabai -m window --toggle split

      # -- resizing --
      cmd + alt - 0 : yabai -m space --balance
      cmd + alt - f : yabai -m window --toggle zoom-fullscreen
      cmd + alt + shift - f  : yabai -m window --toggle zoom-parent

      ## hyper - 0x18  : yabai -m window --toggle zoom-parent

      # uses brackets left: [ right: ]
      cmd + alt - 0x21 : yabai -m window --resize left:-20:0
      cmd + alt + shift - 0x21 : yabai -m window --resize left:20:0
      cmd + alt - 0x1E : yabai -m window --resize right:20:0
      cmd + alt + shift - 0x1E : yabai -m window --resize right:-20:0

      # uses + and -
      cmd + alt - 0x1B : yabai -m window --resize top:0:20
      cmd + alt +shift - 0x1B : yabai -m window --resize top:0:-20
      cmd + alt - 0x18 : yabai -m window --resize bottom:0:20
      cmd + alt + shift - 0x18 : yabai -m window --resize bottom:0:-20

      # -- floating windows --
      cmd + alt + ctrl - f : yabai -m window --toggle float; \
                            yabai -m window --grid 4:4:1:1:2:2

      # floating window to left half & right half
      ## cmd + alt - left : yabai -m window --grid 1:2:0:0:1:1
      ## cmd + alt - right : yabai -m window --grid 1:2:1:0:1:1

      # -- focusing spaces --
      cmd + alt - 1 : yabai -m space --focus 1
      cmd + alt - 2 : yabai -m space --focus 2
      cmd + alt - 3 : yabai -m space --focus 3
      cmd + alt - 4 : yabai -m space --focus 4
      cmd + alt - 5 : yabai -m space --focus 5
      cmd + alt - 6 : yabai -m space --focus 6
      cmd + alt - 7 : yabai -m space --focus 7
      cmd + alt - 8 : yabai -m space --focus 8

      # -- moving to another "space" on the current display --
      shift + cmd + alt - left : yabai -m window --space prev --focus
      shift + cmd + alt - right : yabai -m window --space next --focus

      shift + cmd + alt - 1 : yabai -m window --space 1 --focus
      shift + cmd + alt - 2 : yabai -m window --space 2 --focus
      shift + cmd + alt - 3 : yabai -m window --space 3 --focus
      shift + cmd + alt - 4 : yabai -m window --space 4 --focus
      shift + cmd + alt - 5 : yabai -m window --space 5 --focus
      shift + cmd + alt - 6 : yabai -m window --space 6 --focus
      shift + cmd + alt - 7 : yabai -m window --space 7 --focus
      shift + cmd + alt - 8 : yabai -m window --space 8 --focus

      # -- moving to another to another display --
      cmd + ctrl - 1 : yabai -m window --display 1; yabai -m display --focus 1
      cmd + ctrl - 2 : yabai -m window --display 2; yabai -m display --focus 2
      cmd + ctrl - 3 : yabai -m window --display 3; yabai -m display --focus 3

      # -- focus another display --
      hyper - 1 : yabai -m display --focus 1
      hyper - 2 : yabai -m display --focus 2
      hyper - 3 : yabai -m display --focus 3
      hyper - b : yabai -m display --focus prev || yabai -m display --focus recent
      hyper - n : yabai -m display --focus next || yabai -m display --focus recent

      # -- stack windows onto each other
      ## shift + cmd - b : yabai -m window --focus stack.prev || yabai -m window --focus stack.last
      ## shift + cmd - n : yabai -m window --focus stack.next || yabai -m window --focus stack.first
      ## shift + cmd - h : yabai -m window --stack west
      ## shift + cmd - j : yabai -m window --stack south
      ## shift + cmd - k : yabai -m window --stack north
      ## shift + cmd - l : yabai -m window --stack east
    '';
  };
}
