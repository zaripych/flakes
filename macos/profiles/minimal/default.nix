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
    all-packages._1password-gui
  ];

  mas-apps = { };

  modules = [
    inputs.mac-app-utils.darwinModules.default
    ../../modules/synced-apps.nix
  ];

in
{
  inherit nixpkgs;

  inherit system-packages;
  inherit synced-apps;
  inherit mas-apps;

  inherit modules;
}
