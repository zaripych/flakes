{
  description = "A nix-darwin configuration flake for my personal laptops";

  inputs = {
    systems.url = "github:nix-systems/aarch64-darwin";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";

    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";
    flake-utils-plus.inputs.flake-utils.follows = "flake-utils";

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    mac-app-utils.url = "github:hraban/mac-app-util";
    mac-app-utils.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-utils.inputs.flake-utils.follows = "flake-utils";
    mac-app-utils.inputs.systems.follows = "systems";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";
    nix-vscode-extensions.inputs.flake-utils.follows = "flake-utils";

    call-flake.url = "github:divnix/call-flake";
  };

  outputs =
    inputs@{ self
    , flake-utils-plus
    , nix-darwin
    , ...
    }:
    let
      makeMkHostConfig = import ./libraries/makeMkHostConfig.nix;
      pkgs = self.pkgs.aarch64-darwin.nixpkgs;
      mkHostConfig = makeMkHostConfig {
        nixpkgs = pkgs;
        system = pkgs.system;
        lib = self.lib.aarch64-darwin;
        selfInputs = inputs;
      };
    in
    flake-utils-plus.lib.mkFlake
      {
        inherit self inputs;

        channelsConfig = { allowUnfree = true; };

        sharedOverlays = [
          (import ./features/nodejs-version/overlay.nix)
        ];

        outputsBuilder = channels: {
          lib =
            let
              lib = rec {
                patchInputs = import ./features/patch-inputs/default.nix {
                  pkgs = channels.nixpkgs;
                };
                featuresPath = ./features;
                useFeatureAt = import ./libraries/useFeatureAt.nix { };
                # These could be used by the host configurations to disable/enable features
                features = import ./features.nix { inherit useFeatureAt; };
                overlays = {
                  nodejs-version = useFeatureAt ./features/nodejs-version/overlay.nix;
                };
                profiles = {
                  default = useFeatureAt ./profiles/default/module.nix;
                  minimal = useFeatureAt ./profiles/minimal/module.nix;
                };
              };
              mkHostConfig = makeMkHostConfig {
                nixpkgs = channels.nixpkgs;
                system = channels.nixpkgs.system;
                lib = lib;
                selfInputs = inputs;
              };
              mkFlake = flake-utils-plus.lib.mkFlake;
            in
            {
              inherit (lib) patchInputs featuresPath useFeatureAt features profiles overlays;
              inherit mkHostConfig mkFlake;
            };
        };

        hosts.default = mkHostConfig {
          # Some modules need the username to setup the user's home directory
          username = "rz";
          modules = [
            ./profiles/default/module.nix
            # Should be last
            ./features/trace-packages/module.nix
          ];

          specialArgs = { };
        };

        hosts.minimal = mkHostConfig {
          # Some modules need the username to setup the user's home directory
          username = "rz";
          modules = [
            ./profiles/minimal/module.nix
            # Should be last
            ./features/trace-packages/module.nix
          ];

          specialArgs = { };
        };
      };
}
