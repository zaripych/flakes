{
  description = "A nix-darwin configuration flake for my personal laptops";

  inputs = {
    flakes.url = "path:/Users/rz/Projects/flakes?dir=macos";
  };

  outputs = inputs @ {
    self,
    flakes,
    ...
  }: let
    inherit (flakes.lib) mkFlake mkHostConfig;
  in
    mkFlake {inherit inputs;} {
      systems = [
        "aarch64-darwin"
      ];

      flake.darwinConfigurations.YOUR_HOSTNAME = mkHostConfig {
        modulesPlatform = "aarch64-darwin";
        specialArgs = {
          username = "YOUR_USERNAME";
        };
        modules = [
          {
            nixpkgs.hostPlatform = "aarch64-darwin";
          }
          # Inherit from the default profile in `flakes`
          flakes.darwinModules.default
          {
            outOfStoreLinks = {
              enable = true;
              sourceLocations = {
                "${inputs.flakes.sourceInfo.narHash}" = "~/Projects/flakes";
              };
            };
          }
          {
            # `system-refresh` allows us to refresh the system with
            # minimum fuss, it will expect the current flake to be at
            # `flakePath` and use that path to pass to `darwin-rebuild`
            # which means you only need to run `darwin-refresh` to rebuild
            systemRefresh.enable = true;
            systemRefresh.flakePath = "~/Projects/local-flakes";
            # We are inheriting from `flakes` so we want to refresh
            # the input in case it changes
            systemRefresh.updateInputs = ["flakes"];
            systemRefresh.gitAddPaths = [
              # The flake I'm inheriting from is located at this path
              # and we want to `git add .` there before running
              # `darwin-rebuild` to rebuild the system
              "~/Projects/flakes"
            ];
          }
        ];
      };
    };
}
