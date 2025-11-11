{inputs, ...}: {
  imports = [
    ../features/nix-darwin/module.nix

    ../features/system-refresh/module.nix
    ../features/terminal/module.nix

    ../features/nix/module.nix
    inputs.self.darwinModules.zsh
    ../features/bash/nix-darwin.module.nix
    ../features/atuin/module.nix
    ../features/nvim/module.nix
    ../features/git-config/module.nix
    ../features/powerline-fonts/module.nix

    ../features/enable-sudo-touch/module.nix
    ../features/mouse-and-trackpad/module.nix

    ../features/security/module.nix

    ../features/basic-tools/module.nix
    ../features/nodejs/module.nix
    ../features/pnpm/module.nix
    # AppStore apps require homebrew to be pre-installed
    ../features/app-store-apps/module.nix
    ../features/vscode/module.nix
    ../features/npm-packages/module.nix

    ../features/1password-gui/module.nix
    ../features/docker-desktop/module.nix
    ../features/trace-packages/module.nix
    ../features/television/module.nix
    ./features/yabai/module.nix
    ./features/key-remapping/module.nix
  ];
}
