{
  description = "A very basic flake";

  inputs = {
    systems.url = "github:nix-systems/aarch64-darwin";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";

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
  };

  outputs =
    inputs@{ self
    , flake-utils
    , nix-darwin
    , mac-app-utils
    , home-manager
    , ...
    }:
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


          system = {
            # Used for backwards compatibility, please read the changelog before changing.
            # $ darwin-rebuild changelog
            stateVersion = 5;
            # Set Git commit hash for darwin-version.
            configurationRevision = self.rev or self.dirtyRev or null;

            defaults = {
              # Restart for changes to take an effect.
              NSGlobalDomain."com.apple.trackpad.scaling" = 3.0;
              NSGlobalDomain.KeyRepeat = 2;
              NSGlobalDomain.InitialKeyRepeat = 15;

              trackpad.Clicking = true;
              trackpad.TrackpadThreeFingerDrag = true;
            };
          };

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
                theme = "fino";
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
            ]
            # Add home manager, if it is enabled in the profile
            ++ (
              if (builtins.length (builtins.attrNames (profile.home-manager or { })) > 0)
              then
                [
                  home-manager.darwinModules.home-manager
                  {
                    users.users.${username}.home = "/Users/${username}";

                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;

                    home-manager.sharedModules = [
                      mac-app-utils.homeManagerModules.default
                    ];

                    home-manager.users.${username} = profile.home-manager.home;

                    home-manager.extraSpecialArgs = {
                      inherit inputs;
                      inherit username;
                    };
                  }
                ] else [ ]
            )
            # Add other modules from the profile
            ++ profile.modules;

            specialArgs = {
              inherit inputs;
              inherit username;
              profile = profile;
              pkgs = profile.nixpkgs;
            };
          };

        darwin-system = create-system-using-profile {
          profile = profiles.minimal // profiles.default;
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
