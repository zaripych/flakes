{
  inputs,
  extraSpecialArgs ? {},
  ...
}: attrs: let
  nextAttrs = builtins.removeAttrs attrs ["inputs" "modulesPlatform" "system"];
  nextInputs = builtins.removeAttrs (attrs.inputs or {}) ["self"];
  nixpkgs = attrs.inputs.nixpkgs or inputs.nixpkgs;
  nix-darwin = attrs.inputs.nix-darwin or inputs.nix-darwin;
in
  if attrs.modulesPlatform == "x86_64-linux" || attrs.modulesPlatform == "aarch64-linux"
  then
    (nixpkgs.lib.nixosSystem (nextAttrs
      // {
        specialArgs =
          {
            /**
            Inherit inputs from the flake call and merge with inputs passed to mkHostConfig.
            */
            inputs = inputs // nextInputs;
            modulesPlatform = attrs.modulesPlatform;
          }
          // extraSpecialArgs
          // (attrs.specialArgs or {});
      }))
  else if attrs.modulesPlatform == "x86_64-darwin" || attrs.modulesPlatform == "aarch64-darwin"
  then
    (nix-darwin.lib.darwinSystem (nextAttrs
      // {
        specialArgs =
          {
            /**
            Inherit inputs from the flake call and merge with inputs passed to mkHostConfig.
            */
            inputs = inputs // nextInputs;
            modulesPlatform = attrs.modulesPlatform;
          }
          // extraSpecialArgs
          // (attrs.specialArgs or {});
      }))
  else throw "Unsupported platform: ${attrs.modulesPlatform}"
