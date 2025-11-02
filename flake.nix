{
  description = "A configuration/module flake for my personal laptops";

  inputs = {
    systems.url = "github:nix-systems/aarch64-darwin";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-compat.url = "github:hraban/flake-compat";
    flake-compat.flake = false;

    mac-app-utils.url = "github:hraban/mac-app-util";
    # mac-app-utils.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-utils.inputs.flake-utils.follows = "flake-utils";
    mac-app-utils.inputs.systems.follows = "systems";
    mac-app-utils.inputs.flake-compat.follows = "flake-compat";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs-lib";

    nvf.url = "github:notashelf/nvf";
    nvf.inputs.systems.follows = "systems";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
    nvf.inputs.flake-parts.follows = "flake-parts";
    nvf.inputs.flake-compat.follows = "flake-compat";

    hyprland.url = "github:hyprwm/Hyprland";

    xremap.url = "github:xremap/nix-flake";
    xremap.inputs.nixpkgs.follows = "nixpkgs-unstable";
    xremap.inputs.home-manager.follows = "home-manager";
    xremap.inputs.flake-parts.follows = "flake-parts";
    xremap.inputs.hyprland.follows = "hyprland";
  };

  outputs = inputs @ {
    flake-parts,
    nix-darwin,
    nixpkgs-lib,
    ...
  }: let
    lib = import ./libs/default.nix {
      inherit inputs;
    };
  in
    lib.mkFlake {
      inherit inputs;
    } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      imports = [
        ./options/libs/part.nix
        ./options/nix-darwin/part.nix

        {
          flake.lib = lib;
        }

        ./features/nvim/part.nix
        ./features/zsh/part.nix

        {
          flake.darwinModules.default = ./macos/module.nix;
          flake.nixosModules.default = ./linux/module.nix;

          flake.nixosConfigurations.default = lib.mkHostConfig {
            system = "x86_64-linux";
            modules = [
              ./linux/module.nix
            ];
          };
        }
      ];
    };
}
