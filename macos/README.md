First time setup:

```sh
nix-shell -p gh git
gh auth login
gh repo clone zaripych/flakes ~/Projects/flakes
~/Projects/flakes/macos/bootstrap.sh
```

After a configuration update in one of the modules or profiles:

```sh
darwin-refresh
```

We can reuse from this flake and customize it in your own flake:

```nix
{
  description = "A nix-darwin configuration flake for my work laptop";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flakes.url = "path:/Users/rz/Projects/flakes/macos";
    flakes.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ self, flakes, ... }:
    let
      inherit (flakes.lib.aarch64-darwin) profiles features mkHostConfig;
    in
    flakes.lib.aarch64-darwin.mkFlake {
      inherit self inputs;

      channelsConfig = { allowUnfree = true; };

      hosts.prp-2024 = mkHostConfig {
        flakePath = "~/Projects/local-flakes";
        modules = [
          # Inherit from the default profile in `flakes`
          profiles.default
          {
            # `darwin-refresh` allows us to refresh the system with
            # minimum fuss, it will expect the current flake to be at
            # `flakePath` and use that path to pass to `darwin-rebuild`
            # which means you only need to run `darwin-refresh` to rebuild
            darwinRefresh.enable = true;
            # We are inheriting from `flakes` so we want to refresh
            # the input in case it changes
            darwinRefresh.updateInputs = [ "flakes" ];
            darwinRefresh.gitAddPaths = [
              # The flake I'm inheriting from is located in this path
              # and we want to `git add .` there before running
              # `darwin-rebuild` to rebuild the system
              "/Users/rz/Projects/flakes/macos"
            ];
          }
          # Your custom modules
          ./features/dev-tools/module.nix
          ./features/env-vars/module.nix
          ./features/tailscale/module.nix
          ./features/vault/module.nix
          # Debug which flakes.* modules are used
          features.trace-packages
        ];
        inputPatchingModules = [
        ];
      };
    };
}
```

Now the configuration for a work laptop can remain in a separate flake and
doesn't have to be pushed to a public repository. The `darwin-refresh` command
will take care of updating the system with the latest changes in the parent
flake and the customization flake as well.
