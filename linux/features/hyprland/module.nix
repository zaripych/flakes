{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = [
    # ... other packages
    pkgs.kitty # required for the default Hyprland config
    pkgs.waybar # investigate alternative pkgs.eww later
    pkgs.dunst # notification daemon ? why do I need this ?
    pkgs.swww # wallpaper setter for wayland
    pkgs.rofi-wayland # app launcher
  ];

  environment.sessionVariables = {
    # WLR_NO_HARDWARE_CURSORS = "1";
    /**
    Hint electron apps to use Wayland
    */
    NIXOS_OZONE_WL = "1";
  };

  # desktop portals:
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
}
