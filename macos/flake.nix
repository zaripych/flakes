{
  description = "A very basic flake";

  inputs = {
    systems.url = "github:nix-systems/aarch64-darwin";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, flake-utils, nix-darwin, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        nixpkgs = import inputs.nixpkgs { inherit system; };

        configuration = { pkgs, ... }: {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = with pkgs; [
            nil
            nixpkgs-fmt
            git
            git-lfs
            jq
            fzf
          ];

          # Auto upgrade nix package and the daemon service.
          services.nix-daemon.enable = true;
          # nix.package = pkgs.nix;

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;

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
                  darwin-rebuild switch --flake ~/Projects/flakes/macos
                }
              '';
            };
          };
        };

        defaultDarwinSystem = nix-darwin.lib.darwinSystem {
          modules = [ configuration ];
          specialArgs = { inherit inputs; };
        };
      in
      {
        # Build darwin flake using:
        # $ darwin-rebuild build --flake .#rz-laptop-21
        packages = {
          darwinConfigurations.rz-laptop-21 = defaultDarwinSystem;
          darwinConfigurations.Rinat-Propeller-MBP = defaultDarwinSystem;
        };

        devShells.default = nixpkgs.mkShell {
          packages = with nix-darwin.packages."${system}"; [
            darwin-rebuild
            darwin-version
          ];
        };
      }
    );
}
