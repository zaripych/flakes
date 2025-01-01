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

          username = "rz";

          global-npm-packages = nixpkgs.callPackage ./global-npm-packages
            {
              # Add global npm packages to ./npm-packages/package.json
              # and run `pnpm install` to update the lock file, after which
              # you can run `darwin-refresh` to make them globally available
              pnpm-packages-src = ./npm-packages;
              # Hash of the fetched dependencies, omit it to calculate the
              # hash and then update the value
              pnpm-packages-deps-hash = "sha256-b4DyUQFNJiIUUUQRzMo3KUdFPoAt39n1aEG457GlCJM=";
            };

          systemPackages = pkgs:
            let
              docker-desktop =
                pkgs.callPackage ./packages/docker-desktop/default.nix { };
              arc-browser =
                pkgs.callPackage ./packages/arc-browser/default.nix { };
            in
            with pkgs; [
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

              docker-desktop
              arc-browser
            ];
          syncedApps = pkgs:
            let
              _1password-gui =
                pkgs.callPackage ./packages/1password-gui/default.nix { };
            in
            [
              _1password-gui
            ];

          configuration = { pkgs, ... }: {
            # List packages installed in system profile. To search by name, run:
            # $ nix-env -qaP | grep wget
            environment.systemPackages = systemPackages pkgs;
            environment.syncedApps = syncedApps pkgs;

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

                shellInit = ''
                  # A shortcut to refresh the nix-darwin configuration
                  function darwin-refresh() {
                    darwin-rebuild switch --flake ~/Projects/flakes/macos --print-build-logs $@
                  }
                '';
              };
            };

            homebrew = {
              enable = true;

              masApps = {
                "Amphetamine" = 937984704;
                "Moom Classic" = 419330170;
              };
            };

            security.pam.enableSudoTouchIdAuth = true;
          };

          darwin-system = nix-darwin.lib.darwinSystem {
            modules = [
              configuration
              mac-app-utils.darwinModules.default
              ./modules/synced-apps.nix
            ];
            specialArgs = {
              inherit inputs;
              inherit username;
              pkgs = nixpkgs;
            };
          };
        in
        {
          # Build darwin flake using:
          # $ darwin-rebuild build --flake ./macos#default
          darwinConfigurations.default = darwin-system;
          darwinConfigurations.rz-laptop-21 = darwin-system;
          darwinConfigurations.Rinat-Propeller-MBP = darwin-system;

          devShells.${system}.default = nixpkgs.mkShell {
            packages = with nix-darwin.packages."${system}"; [
              darwin-rebuild
              darwin-version
            ];
          };
        }
      );
}
