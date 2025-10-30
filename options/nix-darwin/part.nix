({
  lib,
  flake-parts-lib,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    literalExpression
    ;
  inherit
    (flake-parts-lib)
    mkSubmoduleOptions
    ;
in {
  options = {
    flake = mkSubmoduleOptions {
      darwinConfigurations = mkOption {
        type = types.lazyAttrsOf types.raw;
        default = {};
        description = ''
          Instantiated `nix-darwin` configurations. Used by `darwin-rebuild`.

          `darwinConfigurations` is for specific machines. If you want to expose
          reusable configurations, add them to [`darwinModules`](#opt-flake.darwinModules)
          in the form of modules, so that you can reference
          them in this or another flake's `darwinConfigurations`.
        '';
        example = literalExpression ''
          {
            my-machine = inputs.nix-darwin.lib.darwinSystem {
              # system is not needed with freshly generated hardware-configuration.nix
              # system = "x86_64-darwin";
              modules = [

              ];
            };
          }
        '';
      };
      darwinModules = mkOption {
        type = types.lazyAttrsOf types.raw;
        default = {};
        description = ''
          Used by `darwin-rebuild` or to compose nix-darwin configurations. These go
          into the `modules` list of a nix-darwin configuration, or can be imported
          in other modules via `imports` option.
        '';
        example = literalExpression ''
          {inputs,...}: {
            imports = [
              inputs.your-flake.darwinModules.someModule
            ];
          }
        '';
      };
    };
  };
})
