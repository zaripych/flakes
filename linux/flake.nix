{
  description = "A Linux-only configuration/module flake for my personal laptops";

  inputs = {
    systems.url = "github:nix-systems/x86_64-linux";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-compat.url = "github:hraban/flake-compat";
    flake-compat.flake = false;

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs-lib";

    nvf.url = "github:notashelf/nvf/v0.8";
    nvf.inputs.systems.follows = "systems";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
    nvf.inputs.flake-parts.follows = "flake-parts";
    nvf.inputs.flake-compat.follows = "flake-compat";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs-unstable";

    xremap.url = "github:xremap/nix-flake";
    xremap.inputs.nixpkgs.follows = "nixpkgs-unstable";
    xremap.inputs.home-manager.follows = "home-manager";
    xremap.inputs.flake-parts.follows = "flake-parts";
    xremap.inputs.hyprland.follows = "hyprland";
  };

  outputs = inputs @ {
    flake-parts,
    nixpkgs-lib,
    ...
  }: let
    lib = import ../libs/default.nix {
      inherit inputs;
    };
  in
    lib.mkFlake {
      inherit inputs;
    } {
      systems = [
        "x86_64-linux"
      ];

      imports = [
        ../options/libs/part.nix

        {
          flake.lib = lib;
        }

        ../features/nvim/part.nix
        ../features/zsh/part.nix

        {
          flake.nixosModules.default = ./module.nix;

          flake.nixosConfigurations.default = lib.mkHostConfig {
            system = "x86_64-linux";
            specialArgs = {
              username = "test-user";
            };
            modules = [
              ./module.nix
              ({lib, ...}: {
                # CI/VM testing configuration adapted from tlaternet-server
                system.stateVersion = "25.05";

                # Define a test user
                users.users.test-user = {
                  isNormalUser = true;
                  home = "/home/test-user";
                  password = "insecure";
                };

                # Disable graphical tty so -curses works
                boot.kernelParams = ["nomodeset"];

                networking.hostName = "test-vm";

                virtualisation.vmVariant = {
                  virtualisation = {
                    memorySize = 2048;
                    cores = 2;
                    graphics = false;
                  };
                };
              })
            ];
          };
        }

        {
          perSystem = {system, ...}: let
            vm = inputs.self.nixosConfigurations.default;
          in {
            packages.vm = vm.config.system.build.vm;

            apps.run-vm = {
              type = "app";
              program = let
                pkgs = inputs.nixpkgs.legacyPackages.${system};
              in
                (pkgs.writeShellScript "run-vm" ''
                  ${vm.config.system.build.vm}/bin/run-test-vm-vm
                '').outPath;
            };
          };
        }
      ];
    };
}
