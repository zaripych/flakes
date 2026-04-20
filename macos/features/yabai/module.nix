{username, ...}: {
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;

    config = {
      window_placement = "second_child";
      # window_topmost = "on";
      window_shadow = "float";
      # window_border = "off";
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
      debug_output = "on";
    };

    extraConfig = ''
      function setup_space {
        local idx="$1"
        local name="$2"
        local layout=''${3:-stack}
        local space=
        echo "setup space $idx : $name with layout $layout"

        space=$(yabai -m query --spaces --space "$idx")
        if [ -z "$space" ]; then
          yabai -m space --create
        fi

        yabai -m space "$idx" --label "$name"
        yabai -m space "$idx" --layout "$layout"
      }

      setup_space 1 "Browser" bsp
      setup_space 2 "Code" stack
      setup_space 3 "Kitty" bsp
      setup_space 4 "Comms" stack
      setup_space 5 "Other" stack

      # Default space
      yabai -m rule --add app=".*" space=^Other

      # Assign apps to spaces
      yabai -m rule --add app="^(Safari|(Google Chrome))$" space=^Browser
      yabai -m rule --add app="^(Code|Visual Studio Code|IntelliJ IDEA|Xcode)$" space=^Code
      yabai -m rule --add app="^(kitty|Terminal)$" title!="^scratch-terminal$" space=Kitty
      yabai -m rule --add app="^(Slack|Messages)$" space=^Comms

      # Disable yabai management for certain apps
      yabai -m rule --add app="^System Information$" manage=off
      yabai -m rule --add app="^System Preferences$" manage=off
      yabai -m rule --add app="^System Settings$" manage=off
      yabai -m rule --add app="^Disk Utility$" manage=off
      yabai -m rule --add title="^(Minecraft.*)$" manage=off
      yabai -m rule --add app="^Leader Key$" manage=off sticky=on

      # Create scratchpad spaces
      yabai -m rule --add app="^kitty$" title="^scratch-terminal$" scratchpad=terminal grid=11:11:1:1:9:9

      # Start non-scratchpad terminal
      if [[ $(yabai -m query --windows | jq 'map(select(.app == "kitty" and .scratchpad == "")) | length') == '0' ]]; then
        open -n -a /etc/profiles/per-user/${username}/bin/kitty --args -1 --working-directory=$HOME;
      fi

      # Automatically hide unfocused scratchpads
      yabai -m signal --add event=application_front_switched action="cat <(yabai -m query --windows --space | jq -r 'map(select(.[\"is-visible\"] == true and .[\"has-focus\"] == false and .scratchpad != \"\") | .scratchpad)[]') | xargs yabai -m window --toggle"

      # If yabairc at ~/.yabairc exists, load it (this allows me to test changes without rebuilding nix-darwin)
      if [ -f /Users/${username}/.yabairc ]; then
        /Users/${username}/.yabairc
      fi

      yabai -m rule --apply

      echo "$(date "+%Y-%m-%d %H:%M:%s") - yabai configuration loaded..."
    '';
  };

  launchd.user.agents.yabai.serviceConfig.StandardOutPath = "/tmp/yabai-stdout.log";
  launchd.user.agents.yabai.serviceConfig.StandardErrorPath = "/tmp/yabai-stderr.log";
}
