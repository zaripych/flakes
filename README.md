First time setup:

```sh
nix-shell -p gh git
gh auth login
gh repo clone zaripych/flakes ~/Projects/flakes
~/Projects/flakes/macos/bootstrap.sh
```

After a configuration update in one of the modules or profiles:

```sh
system-refresh build|switch
```

We can reuse from this flake and customize it in your own flake:

```nix
{
  description = "A nix-darwin configuration flake for my personal laptops";

  inputs = {
    flakes.url = "github:zaripych/flakes";
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

      flake.darwinConfigurations.MY_HOST_NAME = mkHostConfig {
        system = "aarch64-darwin";
        modules = [
          {
            nixpkgs.hostPlatform = "aarch64-darwin";
          }
          # Inherit from the default profile in `flakes`
          flakes.darwinModules.default
          {
            # `system-refresh` allows us to refresh the system with
            # minimum fuss, it will expect the current flake to be at
            # `flakePath` and use that path to pass to rebuild command
            # which means you only need to run `system-refresh` to rebuild
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
          # Add customizations for my work laptop
          ./customizations/my-work-laptop.nix
        ];
      };
    };
}
```

Now the configuration for a work laptop can remain in a separate flake and
doesn't have to be pushed to a public repository. The `system-refresh` command
will take care of updating the system with the latest changes in the parent
flake and the customization flake as well.

## Customizing Git Configuration

The git-config feature provides default git settings. You can override or add personal git settings by adding a custom module:

```nix
{
  flake.darwinConfigurations.MY_HOST_NAME = mkHostConfig {
    system = "aarch64-darwin";
    modules = [
      flakes.darwinModules.default
      {
        systemRefresh.enable = true;
        systemRefresh.flakePath = "~/Projects/local-flakes";
      }
      # Add your personal git settings
      ({username, ...}: {
        home-manager.users.${username} = {
          programs.git.settings = {
            user.name = "Your Name";
            user.email = "your.email@example.com";
            # Add any additional git config here
          };
        };
      })
    ];
  };
}
```

This allows you to keep personal git settings (name, email, signing keys) separate from the shared configuration.

## Customizing Username

You can override the username via the `specialArgs` parameter:

```nix
{
  flake.darwinConfigurations.MY_HOST_NAME = mkHostConfig {
    system = "aarch64-darwin";
    specialArgs = {
      username = "myusername";
    };
    modules = [
      flakes.darwinModules.default
      # ... other modules
    ];
  };
}
```

The `username` parameter is used throughout the configuration, particularly for home-manager settings.
