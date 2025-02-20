{ nixpkgs, system, lib, selfInputs }:
{
  # Modules to include in the host configuration
  modules
  # Path to the current flake's source code on the host
  # Username to use for the host configuration
, username ? "rz"
  # Modules to use to patch the inputs of the flake
, inputPatchingModules ? [ ]
  # Inputs of the current flake
, inputs ? selfInputs
  # Special arguments to pass to the host configuration
, specialArgs ? { }
}: {
  system = system;
  output = "darwinConfigurations";
  builder = selfInputs.nix-darwin.lib.darwinSystem;

  modules = modules;

  specialArgs = {
    username = username;
  } // lib // {
    # Patch inputs of the flake using modules from `inputPatchingModules`
    inputs = lib.patchInputs {
      # We can override both selfInputs and inputs of the current flake
      inputs = selfInputs // inputs;
      args = lib;
      modules = inputPatchingModules;
    };
  } // specialArgs;
}
