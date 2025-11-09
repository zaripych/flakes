{...}: let
  disableApps = apps:
    builtins.concatStringsSep "\n" (builtins.map
      (app: "yabai -m rule --add app='^${app}$' manage=off")
      apps);

  disabledApps = [
    "System Information"
    "System Preferences"
    "System Settings"
    "Disk Utility"
  ];
in {
  services.yabai = {
    enable = true;

    config = {
      window_placement = "second_child";
      window_topmost = "on";
      window_shadow = "float";
      window_border = "off";
      window_opacity = "off";
      insert_feedback_color = "0xffd75f5f";
      split_ratio = "0.50";
      auto_balance = "on";
      mouse_drop_action = "swap";
      layout = "bsp";
      top_padding = 6;
      bottom_padding = 6;
      left_padding = 6;
      right_padding = 6;
      window_gap = 6;
    };

    extraConfig = ''
      ${disableApps disabledApps}

      # float iterm window that emulate guake (floats from bottom)
      yabai -m rule --add app='^iTerm2$' title="^Hotkey Window$" manage=off

      echo "$(date "+%Y-%m-%d %H:%M:%s") - yabai configuration loaded..."
    '';
  };
}
