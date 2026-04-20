{username, ...}: {
  home-manager.users.${username} = {
    programs.kitty = {
      enable = true;

      settings = {
        font_name = "Fira Code";
        font_size = 14.0;
        macos_option_as_alt = "left";
        editor = "nvim"; # or "vim", "nano", etc.
        confirm_os_window_close = 0;

        scrollback_lines = 100000;
        scrollback_pager_history_size = 100; # MB of additional history stored on disk
        scrollback_pager = "nvim -c 'let f=tempname() | silent execute \"write! \" . f | silent execute \"te cat \" . f' -c 'nnoremap q :qa!<CR>' -";
      };

      themeFile = "Catppuccin-Mocha";

      keybindings = {
        # Word-based cursor movement
        "alt+left" = "send_text all \\x1b\\x62"; # Move backward by word (ESC+b)
        "alt+right" = "send_text all \\x1b\\x66"; # Move forward by word (ESC+f)

        # Home/End behavior
        "cmd+left" = "send_text all \\x01"; # Move to beginning of line (Ctrl+A)
        "cmd+right" = "send_text all \\x05"; # Move to end of line (Ctrl+E)

        # Word deletion
        "alt+backspace" = "send_text all \\x17"; # Delete word backward (Ctrl+W)

        # Search scrollback
        "cmd+f" = "show_scrollback";
      };
    };
  };
}
