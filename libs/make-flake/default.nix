{
  inputs,
  extraSpecialArgs ? {},
  ...
}: attrs: modules:
inputs.flake-parts.lib.mkFlake {
  /**
  Inherit inputs from the flake call and merge with inputs passed to mkHostConfig.
  */
  inputs = inputs // attrs.inputs;
  specialArgs = (attrs.specialArgs or {}) // extraSpecialArgs;
}
modules
