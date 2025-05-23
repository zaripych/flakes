{ pkgs }:
# This function evaluates all modules and patches the inputs
# using `inputsToPatch` attribute of the config.
{ inputs
, modules
, args
,
}:
let
  result =
    if builtins.length modules > 0 then
      (builtins.trace "Evaluating modules to find inputs to patch..." pkgs.lib.evalModules {
        modules = modules;
        specialArgs = args // {
          inherit pkgs;
          inherit inputs;
        };
      }) else { config = { inputs = inputs; }; };
in
if builtins.hasAttr "inputs" result.config
then result.config.inputs
else inputs

