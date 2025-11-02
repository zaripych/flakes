{inputs, ...}: {
  imports = [
    ../features/system-refresh/module.nix

    # Password management
    ../features/basic-tools/module.nix

    ../features/home-manager/module.nix

    ../features/nvim/module.nix

    ../features/nix/module.nix

    ./features/hyprland/module.nix
    ./features/steam/module.nix
    ./features/key-remapping/module.nix

    # ../features/enable-sudo-touch/module.nix
    # ../features/mouse-and-trackpad/module.nix
    ../features/git-config/module.nix
    ../features/powerline-fonts/module.nix

    ../features/nodejs/module.nix
    ../features/pnpm/module.nix

    # ../features/vscode/module.nix
    ../features/npm-packages/module.nix

    ../features/television/module.nix

    inputs.self.nixosModules.zsh
  ];
}
