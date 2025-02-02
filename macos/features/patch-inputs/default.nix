{ pkgs }:
# This function evaluates all modules and patches the inputs
# using `inputsToPatch` attribute of the config.
{ inputs
, modules
, args
,
}:
let
  result = pkgs.lib.evalModules {
    modules = modules;
    specialArgs = args // {
      inherit pkgs;
      inherit inputs;
    };
  };
in
if builtins.hasAttr "inputs" result.config
then result.config.inputs
else inputs

