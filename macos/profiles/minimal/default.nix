{ inputs
, system
, username
}:
let
  nixpkgs = import inputs.nixpkgs {
    inherit system;

    config = {
      allowUnfree = true;
    };

    overlays = [
      (final: prev: {
        nodejs = prev.nodejs_20;
      })
    ];
  };

  system-packages = with nixpkgs; [
    nil
    nixpkgs-fmt
    nix-search-cli
    git
    git-lfs
    jq
    fzf
    nodejs
    nodePackages.pnpm
    _1password-cli
  ];

  synced-apps = [
  ];

  mas-apps = { };

  modules = [
    inputs.mac-app-utils.darwinModules.default
    ../../modules/synced-apps.nix
    ../../modules/oh-my-zsh.nix
  ];

  oh-my-zsh-plugins = [
    "git"
  ];

  fonts = [
  ];

in
{
  inherit nixpkgs;

  inherit system-packages;
  inherit synced-apps;
  inherit mas-apps;

  inherit oh-my-zsh-plugins;
  inherit fonts;

  inherit modules;
}
