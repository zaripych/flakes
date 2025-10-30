{
  inputs,
  extraSpecialArgs ? {},
  ...
}: attrs:
if attrs.system == "x86_64-linux" || attrs.system == "aarch64-linux"
then
  (inputs.nixpkgs.lib.nixosSystem (attrs
    // {
      specialArgs =
        (attrs.specialArgs or {})
        // {
          /**
          Inherit inputs from the flake call and merge with inputs passed to mkHostConfig.
          */
          inputs = inputs // (attrs.inputs or {});
          system = attrs.system;
        }
        // extraSpecialArgs;
    }))
else if attrs.system == "x86_64-darwin" || attrs.system == "aarch64-darwin"
then
  (inputs.nix-darwin.lib.darwinSystem (attrs
    // {
      specialArgs =
        (attrs.specialArgs or {})
        // {
          /**
          Inherit inputs from the flake call and merge with inputs passed to mkHostConfig.
          */
          inputs = inputs // (attrs.inputs or {});
          system = attrs.system;
        }
        // extraSpecialArgs;
    }))
else throw "Unsupported system: ${attrs.system}"
