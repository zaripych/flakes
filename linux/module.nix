{...}: {
  imports = [
    ../features/system-refresh/module.nix
    ../features/home-manager/module.nix

    ../features/nvim/module.nix

    ../features/nix/module.nix
    ../features/zsh/nixos.module.nix

    ./features/hyprland/module.nix
    ./features/steam/module.nix

    # ../features/enable-sudo-touch/module.nix
    # ../features/mouse-and-trackpad/module.nix
    # ../features/git-config/module.nix
    # ../features/powerline-fonts/module.nix
    # ../features/security/module.nix

    # ../features/basic-tools/module.nix
    # ../features/nodejs-version/module.nix
    # ../features/pnpm/module.nix

    # ../features/app-store-apps/module.nix
    # ../features/vscode/module.nix
    # ../features/npm-packages/module.nix

    # ../features/1password-gui/module.nix
    # ../features/docker-desktop/module.nix
  ];
}
