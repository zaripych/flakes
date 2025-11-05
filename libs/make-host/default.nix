{
  inputs,
  extraSpecialArgs ? {},
  ...
}: attrs: let
  nextAttrs = builtins.removeAttrs attrs ["inputs"];
  nextInputs = builtins.removeAttrs (attrs.inputs or {}) ["self"];
  nixpkgs = attrs.inputs.nixpkgs or inputs.nixpkgs;
  nix-darwin = attrs.inputs.nix-darwin or inputs.nix-darwin;
in
  if attrs.system == "x86_64-linux" || attrs.system == "aarch64-linux"
  then
    (nixpkgs.lib.nixosSystem (nextAttrs
      // {
        specialArgs =
          {
            /**
            Inherit inputs from the flake call and merge with inputs passed to mkHostConfig.
            */
            inputs = inputs // nextInputs;
            system = attrs.system;
          }
          // extraSpecialArgs
          // (attrs.specialArgs or {});
      }))
  else if attrs.system == "x86_64-darwin" || attrs.system == "aarch64-darwin"
  then
    (nix-darwin.lib.darwinSystem (nextAttrs
      // {
        specialArgs =
          {
            /**
            Inherit inputs from the flake call and merge with inputs passed to mkHostConfig.
            */
            inputs = inputs // nextInputs;
            system = attrs.system;
          }
          // extraSpecialArgs
          // (attrs.specialArgs or {});
      }))
  else throw "Unsupported system: ${attrs.system}"
