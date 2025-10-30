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
      lib = mkOption {
        type = types.lazyAttrsOf types.raw;
        default = {};
        description = ''
          Reusable Nix expressions that can be imported in other parts of the flake.
        '';
        example = literalExpression ''

        '';
      };
    };
  };
})
