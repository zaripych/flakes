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
      mkHostConfig =
        { modules
        , flakePath ? "~/Projects/flakes"
        , username ? "rz"
        , inputPatchingModules ? [ ]
        , specialArgs ? { }
        }: {
          system = "aarch64-darwin";
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

          specialArgs =
            let
              args = {
                # A tool to figure out which modules have been used in the configuration
                # this is supposed to be used every time we refer/import a module, ie
                # imports = [ (useFeatureAt "module-name") ];
                useFeatureAt = self.lib.aarch64-darwin.useFeatureAt;
                # Path to nixpkgs modules, this allows us to use nixos modules in nix-darwin
                nixpkgsModulesPath = self.lib.aarch64-darwin.nixpkgsModulesPath;
                # Path to the collection of builtin features/modules that constitute the
                # `default` and `minimal` profiles
                featuresPath = ./features;
                # Username to use for the configurations
                username = username;
                # Path to the checked out location of the configuration flake
                flakePath = flakePath;
              };
            in
            args // {
              # Patch inputs of the flake using modules from `inputPatchingModules`
              inputs = self.lib.aarch64-darwin.patchInputs {
                inherit inputs;
                inherit args;
                modules = inputPatchingModules;
              };
            } // specialArgs;
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
          lib = {
            patchInputs = import ./features/patch-inputs/default.nix {
              pkgs = channels.nixpkgs;
            };
            nixpkgsModulesPath = toString (inputs.nixpkgs + "/nixos/modules");
            featuresPath = ./features;
            useFeatureAt = import ./libraries/useFeatureAt.nix { };
            mkHostConfig = mkHostConfig;
          };
        };
        hosts.default = mkHostConfig
          {
            modules = [
              ./profiles/default/module.nix
              # Should be last
              ./features/trace-packages/module.nix
            ];
            inputPatchingModules = [
              # ./features/patching-home-manager-for-vscode-profiles/module.nix
            ];
          };
        hosts.minimal = mkHostConfig
          {
            modules = [
              ./profiles/minimal/module.nix
              # Should be last
              ./features/trace-packages/module.nix
            ];
            inputPatchingModules = [
              # ./features/patching-home-manager-for-vscode-profiles/module.nix
            ];
          };
      };
}
