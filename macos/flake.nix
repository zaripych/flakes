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
      makeMkHostConfig =
        { nixpkgs, system, lib }:
        { modules
        , flakePath ? "~/Projects/flakes"
        , username ? "rz"
        , inputPatchingModules ? [ ]
        , specialArgs ? { }
        }: {
          system = system;
          output = "darwinConfigurations";
          builder = nix-darwin.lib.darwinSystem;

          modules = [
            ({ inputs
             , ...
             }: {
              system = {
                # Used for backwards compatibility, please read the changelog before changing.
                # $ darwin-rebuild changelog
                stateVersion = 5;
                # Set Git commit hash for darwin-version.
                configurationRevision = (inputs.nix-darwin.rev or inputs.nix-darwin.dirtyRev or null);
              };
            })
          ] ++ modules;

          specialArgs = {
            username = username;
            flakePath = flakePath;
          } // lib // {
            # Patch inputs of the flake using modules from `inputPatchingModules`
            inputs = lib.patchInputs {
              inherit inputs;
              args = lib;
              modules = inputPatchingModules;
            };
          } // specialArgs;
        };
      pkgs = self.pkgs.aarch64-darwin.nixpkgs;
      mkHostConfig = makeMkHostConfig {
        nixpkgs = pkgs;
        system = pkgs.system;
        lib = self.lib.aarch64-darwin;
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
                nixpkgsModulesPath = toString (inputs.nixpkgs + "/nixos/modules");
                featuresPath = ./features;
                useFeatureAt = import ./libraries/useFeatureAt.nix { };

                # These could be used by the host configurations to disable/enable features
                features = {
                  _1password-gui = useFeatureAt ./features/1password-gui/module.nix;
                  arc-browser = useFeatureAt ./features/arc-browser/module.nix;
                  darwin-refresh = useFeatureAt ./features/darwin-refresh/module.nix;
                  direnv = useFeatureAt ./features/direnv/module.nix;
                  docker-desktop = useFeatureAt ./features/docker-desktop/module.nix;
                  enable-sudo-touch = useFeatureAt ./features/enable-sudo-touch/module.nix;
                  fix-app-symlinks = useFeatureAt ./features/fix-app-symlinks/module.nix;
                  git-config = useFeatureAt ./features/git-config/module.nix;
                  global-npm-packages = useFeatureAt ./features/global-npm-packages/module.nix;
                  home-manager = useFeatureAt ./features/home-manager/module.nix;
                  mouse-and-trackpad = useFeatureAt ./features/mouse-and-trackpad/module.nix;
                  nix = useFeatureAt ./features/nix/module.nix;
                  nixos-module-compat = useFeatureAt ./features/nixos-module-compat/module.nix;
                  patch-inputs = useFeatureAt ./features/patch-inputs/module.nix;
                  patching-home-manager-for-vscode-profiles = useFeatureAt ./features/patching-home-manager-for-vscode-profiles/module.nix;
                  pnpm = useFeatureAt ./features/pnpm/module.nix;
                  powerline-fonts = useFeatureAt ./features/powerline-fonts/module.nix;
                  security = useFeatureAt ./features/security/module.nix;
                  synced-applications = useFeatureAt ./features/synced-applications/module.nix;
                  trace-packages = useFeatureAt ./features/trace-packages/module.nix;
                  zsh = useFeatureAt ./features/zsh/module.nix;
                };

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
              };
              mkFlake = flake-utils-plus.lib.mkFlake;
            in
            {
              inherit (lib) patchInputs nixpkgsModulesPath featuresPath useFeatureAt features profiles overlays;
              inherit mkHostConfig mkFlake;
            };
        };

        hosts.default = mkHostConfig {
          modules = [
            ./profiles/default/module.nix
            # Should be last
            ./features/trace-packages/module.nix
          ];
          inputPatchingModules = [
          ];
        };
        hosts.minimal = mkHostConfig {
          modules = [
            ./profiles/minimal/module.nix
            # Should be last
            ./features/trace-packages/module.nix
          ];
          inputPatchingModules = [
          ];
        };
      };
}
