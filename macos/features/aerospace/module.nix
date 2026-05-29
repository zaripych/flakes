{...}: let
  # after-startup-command runs from launchd with PATH=/usr/bin:/bin:/usr/sbin:/sbin,
  # so use the system profile path instead of relying on `aerospace` resolution.
  aerospace = "/run/current-system/sw/bin/aerospace";
in {
  # Enable Mission Control "Group windows by application" for better AeroSpace compatibility.
  # Equivalent to: defaults write com.apple.dock expose-group-apps -bool true
  system.defaults.dock.expose-group-apps = true;

  services.aerospace = {
    enable = true;
    settings.after-startup-command = [
      "exec-and-forget sleep 2; window_id=$(${aerospace} list-windows --workspace 2 --format \"%{window-id}\" | head -n1); [ -n \"$window_id\" ] && ${aerospace} layout --window-id \"$window_id\" accordion"
    ];
    settings.on-window-detected = [
      {
        "if".app-id = "com.google.Chrome";
        run = ["move-node-to-workspace 1"];
      }
      {
        "if".app-id = "com.apple.Safari";
        run = ["move-node-to-workspace 1"];
      }
      {
        "if".app-id = "com.microsoft.VSCode";
        run = ["move-node-to-workspace 2"];
      }
      {
        "if".app-id = "com.jetbrains.intellij";
        run = ["move-node-to-workspace 2"];
      }
      {
        "if".app-id = "com.apple.dt.Xcode";
        run = ["move-node-to-workspace 2"];
      }
      {
        "if".app-id = "net.kovidgoyal.kitty";
        run = ["move-node-to-workspace 3"];
      }
      {
        "if".app-id = "com.tinyspeck.slackmacgap";
        run = ["move-node-to-workspace 4"];
      }
      {
        "if".app-id = "com.apple.MobileSMS";
        run = ["move-node-to-workspace 4"];
      }
    ];
    settings.mode.main.binding = {
      alt-1 = "workspace 1";
      alt-2 = "workspace 2";
      alt-3 = "workspace 3";
      alt-4 = "workspace 4";
      alt-5 = "workspace 5";
      alt-6 = "workspace 6";
      alt-7 = "workspace 7";
      alt-8 = "workspace 8";
      alt-9 = "workspace 9";

      alt-h = "focus left";
      alt-j = "focus down";
      alt-k = "focus up";
      alt-l = "focus right";

      alt-shift-1 = "move-node-to-workspace 1";
      alt-shift-2 = "move-node-to-workspace 2";
      alt-shift-3 = "move-node-to-workspace 3";
      alt-shift-4 = "move-node-to-workspace 4";
      alt-shift-5 = "move-node-to-workspace 5";
      alt-shift-6 = "move-node-to-workspace 6";
      alt-shift-7 = "move-node-to-workspace 7";
      alt-shift-8 = "move-node-to-workspace 8";
      alt-shift-9 = "move-node-to-workspace 9";

      alt-shift-h = "move left";
      alt-shift-j = "move down";
      alt-shift-k = "move up";
      alt-shift-l = "move right";

      alt-f = "fullscreen";
    };
  };
}
