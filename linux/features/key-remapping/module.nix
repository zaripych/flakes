{
  inputs,
  username,
  pkgs,
  ...
}: let
  # Override xremap to use hyprland 0.4.0-beta.3 to fix socket parsing issues
  # See: https://github.com/xremap/xremap/discussions/646
  xremapWithHyprlandFix = pkgs.callPackage ./xremap.package.nix {};
in {
  imports = [
    inputs.xremap.nixosModules.default
  ];

  services.xremap = {
    enable = true;
    userName = username;
    serviceMode = "user";
    package = xremapWithHyprlandFix;

    withHypr = true;
    watch = true;
    debug = true;

    yamlConfig = ''
      modmap:
        - name: remap Ctrl to Super in Firefox
          remap:
            LeftMeta: LeftCtrl
          application:
            only: firefox
      keymap:
        - name: main remaps
          remap:
            super-f:
              launch: [/run/current-system/sw/bin/firefox]
        - name: more firefox stuff
          remap:
            super-t: ctrl-t
          application:
            only: firefox
    '';
  };
}
