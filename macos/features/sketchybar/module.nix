{
  pkgs,
  username,
  ...
}: {
  imports = [
    ../../../features/home-manager/module.nix
  ];

  fonts = {
    packages = [
      pkgs.sketchybar-app-font
    ];
  };

  home-manager.users."${username}" = {
    programs.sketchybar = {
      enable = true;
      service.enable = true;
      includeSystemPath = true;

      configType = "lua";

      config = {
        source = ./config;
        recursive = true;
      };
    };

    # home.activation.createSketchyBarConfig = inputs.home-manager.lib.hm.dag.entryBefore ["linkGeneration"] ''
    #   rm -rf "$HOME/.config/sketchybar"
    #   ln -s "$HOME/Projects/flakes/macos/features/sketchybar/config/" "$HOME/.config/sketchybar"
    # '';
  };
}
