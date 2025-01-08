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

  all-packages = import ../../packages/all-packages.nix { inherit nixpkgs; };

  global-npm-packages = nixpkgs.callPackage ../../global-npm-packages
    {
      # Add global npm packages to ./npm-packages/package.json
      # and run `pnpm install` to update the lock file, after which
      # you can run `darwin-refresh` to make them globally available
      pnpm-packages-src = ./npm-packages;
      # Hash of the fetched dependencies, omit it to calculate the
      # hash and then update the value
      pnpm-packages-deps-hash = "sha256-b4DyUQFNJiIUUUQRzMo3KUdFPoAt39n1aEG457GlCJM=";
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
    global-npm-packages
    _1password-cli

    iterm2
    all-packages.docker-desktop
    all-packages.arc-browser
  ];

  synced-apps = [
    all-packages._1password-gui
  ];

  mas-apps = {
    "Amphetamine" = 937984704;
    "Moom Classic" = 419330170;
    "Slack" = 803453959;
  };

  modules = [
    inputs.mac-app-utils.darwinModules.default
    ../../modules/synced-apps.nix
    ../../modules/oh-my-zsh.nix
  ];

  oh-my-zsh-plugins = [
    "git"
  ];

  fonts = with nixpkgs; [
    powerline-fonts
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
