{
  /**
  These are default inputs used by my reusable flake. When the flake is used
  as input in other flakes, they are supposed to pass their own `inputs` to
  mkFlake and/or mkHostConfig to override these inputs.

  To allow this `inputs` inheritance behavior we define mkHostConfig and mkFlake.
  */
  inputs,
}: let
  lib = {
    useFeatureAt = import ./use-feature-at/default.nix {};
  };
in
  lib
  // {
    mkHostConfig = import ./make-host/default.nix {
      inherit inputs;
      extraSpecialArgs = {
        lib = inputs.nixpkgs-lib.lib // lib;
        username = "rz";
      };
    };
    mkFlake = import ./make-flake/default.nix {
      inherit inputs;
      extraSpecialArgs = {
        lib = inputs.nixpkgs-lib.lib // lib;
      };
    };
  }
