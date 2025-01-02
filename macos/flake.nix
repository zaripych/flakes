{
  description = "A very basic flake";

  inputs = {
    systems.url = "github:nix-systems/aarch64-darwin";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    mac-app-utils.url = "github:hraban/mac-app-util";
    mac-app-utils.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-utils.inputs.flake-utils.follows = "flake-utils";
    mac-app-utils.inputs.systems.follows = "systems";
  };

  outputs = inputs@{ self, flake-utils, nix-darwin, mac-app-utils, ... }:
    flake-utils.lib.eachDefaultSystemPassThrough
      (system:
        let
          username = "rz";

          profiles = {
            default = import ./profiles/default/default.nix {
              inherit inputs system username;
            };
            minimal = import ./profiles/minimal/default.nix {
              inherit inputs system username;
            };
          };

          configuration = { pkgs, profile, ... }: {
            # List packages installed in system profile. To search by name, run:
            # $ nix-env -qaP | grep wget
            environment.systemPackages = profile.system-packages;
            environment.syncedApps = profile.synced-apps;

            # Auto upgrade nix package and the daemon service.
            services.nix-daemon.enable = true;
            nix.package = pkgs.nix;

            # Necessary for using flakes on this system.
            nix.settings.experimental-features = "nix-command flakes";

            # Set Git commit hash for darwin-version.
            system.configurationRevision = self.rev or self.dirtyRev or null;

            # Used for backwards compatibility, please read the changelog before changing.
            # $ darwin-rebuild changelog
            system.stateVersion = 5;

            # The platform the configuration will be used on.
            nixpkgs.hostPlatform = system;

            programs = {
              direnv = {
                enable = true;
              };

              zsh = {
                enable = true;
                enableCompletion = true;

                enableFzfCompletion = true;
                enableFzfGit = true;
                enableFzfHistory = true;

                enableFastSyntaxHighlighting = false;

                ohMyZsh = {
                  enable = builtins.length profile.oh-my-zsh-plugins > 0;
                  plugins = profile.oh-my-zsh-plugins;
                  theme = "agnoster";
                };

                shellInit = ''
                  # A shortcut to refresh the nix-darwin configuration
                  function darwin-refresh() {
                    darwin-rebuild switch --flake ~/Projects/flakes/macos --print-build-logs $@
                  }
                '';
              };
            };

            homebrew = {
              enable = builtins.length (builtins.attrNames profile.mas-apps) > 0;

              masApps = profile.mas-apps;
            };

            fonts = {
              packages = profile.fonts;
            };

            security.pam.enableSudoTouchIdAuth = true;
          };

          create-system-using-profile = { profile }:
            nix-darwin.lib.darwinSystem {
              modules = [
                configuration
                ./modules/oh-my-zsh.nix
              ] ++ profile.modules;
              specialArgs = {
                inherit inputs;
                inherit username;
                profile = profile;
                pkgs = profile.nixpkgs;
              };
            };

          darwin-system = create-system-using-profile {
            profile = profiles.default;
          };
          darwin-system-minimal = create-system-using-profile {
            profile = profiles.minimal;
          };
        in
        {
          # Build darwin flake using:
          # $ darwin-rebuild build --flake ./macos#default
          darwinConfigurations.default = darwin-system;
          darwinConfigurations.minimal = darwin-system-minimal;
          darwinConfigurations.rz-laptop-21 = darwin-system;
          darwinConfigurations.Rinat-Propeller-MBP = darwin-system;

          devShells.${system}.default = profiles.default.nixpkgs.mkShell {
            packages = with nix-darwin.packages."${system}"; [
              darwin-rebuild
              darwin-version
            ];
          };
        }
      );
}
