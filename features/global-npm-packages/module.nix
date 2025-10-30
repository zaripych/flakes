{ pkgs, lib, config, ... }: {
  options = {
    globalNpmPackages.enable = lib.mkEnableOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to install global npm packages.
      '';
    };

    globalNpmPackages.packages = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule (
        {
          options = {
            src = lib.mkOption {
              type = lib.types.oneOf [ lib.types.str lib.types.path ];
              description = ''
                The path to the directory with package.json and pnpm-lock.yaml files to install global npm packages from.
              '';
            };
            hash = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The hash of the dependencies fetched by pnpm from the packagesSrc.
              '';
            };
          };
        })
      );
      default = [ ];
      description = ''
        The list of global npm packages to install
      '';
    };
  };

  config = lib.mkIf config.globalNpmPackages.enable {
    environment.systemPackages = builtins.map
      (package:
        (pkgs.callPackage ./default.nix {
          src = package.src;
          hash = package.hash;
        })
      )
      config.globalNpmPackages.packages;
  };
}
