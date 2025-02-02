{ pkgs, lib, config, inputs, ... }: {
  options = {
    inputs = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.raw;
      default = inputs;
      description = ''
        A record of inputs that can be patched by other modules.
      '';
    };

    inputsToPatch = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf (lib.types.submodule {
        options = {
          url = lib.mkOption {
            type = lib.types.str;
            description = ''
              The URL of the patch to apply.
            '';
          };
          hash = lib.mkOption {
            type = lib.types.str;
            description = ''
              The hash of the patch to apply.
            '';
          };
        };
      }));
      default = { };
      description = ''
        A record of patches to apply.
      '';
    };
  };

  config = {
    inputs = inputs // (builtins.mapAttrs
      (name: input: (
        if lib.hasAttr name config.inputsToPatch
        then
          let
            applyPatches = (import ./applyPatches.nix {
              inherit (pkgs) lib;
            });
            patched = applyPatches {
              inherit pkgs;
              name = "${name}-patched-src";
              src = inputs.${name};
              patches = builtins.getAttr name config.inputsToPatch;
              # Inherit the follows of the original input
              lockFileEntries =
                let
                  lockFile = pkgs.lib.importJSON ../../flake.lock;
                  root = lockFile.nodes.${name};
                  rootInputs = if builtins.hasAttr "inputs" root then builtins.attrNames root.inputs else [ ];
                  allRootInputNodes = builtins.listToAttrs (builtins.map (name: { inherit name; value = lockFile.nodes.${name}; }) rootInputs);
                  filteredLockFileEntries = {
                    root = lockFile.nodes.${name};
                  } // allRootInputNodes;
                in
                filteredLockFileEntries;
            };
          in
          patched
        else
          input
      ))
      config.inputsToPatch);
  };
}
