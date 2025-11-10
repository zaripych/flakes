{username, ...}: {
  home-manager.users.${username} = {
    programs.kitty = {
      enable = true;

      settings = {
        font_size = 14.0;
        macos_option_as_alt = "left";
        editor = "nvim";  # or "vim", "nano", etc.
        confirm_os_window_close = 0;
      };

      keybindings = {
        # Word-based cursor movement
        "alt+left" = "send_text all \\x1b\\x62";  # Move backward by word (ESC+b)
        "alt+right" = "send_text all \\x1b\\x66"; # Move forward by word (ESC+f)

        # Home/End behavior
        "cmd+left" = "send_text all \\x01";  # Move to beginning of line (Ctrl+A)
        "cmd+right" = "send_text all \\x05"; # Move to end of line (Ctrl+E)

        # Word deletion
        "alt+backspace" = "send_text all \\x17"; # Delete word backward (Ctrl+W)
      };
    };
  };
}
