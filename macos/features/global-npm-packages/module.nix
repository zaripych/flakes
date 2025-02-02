{ pkgs, lib, config, ... }: {
  options = {
    globalNpmPackages.enable = lib.mkEnableOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to install global npm packages.
      '';
    };

    globalNpmPackages.packagesSrc = lib.mkOption {
      type = lib.types.path;
      default = "";
      description = ''
        The path to the directory with package.json and pnpm-lock.yaml files to install global npm packages from.
      '';
    };

    globalNpmPackages.packagesHash = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        The hash of the dependencies fetched by pnpm from the packagesSrc.
      '';
    };
  };

  config = lib.mkIf config.globalNpmPackages.enable {
    environment.systemPackages = [
      (pkgs.callPackage ./default.nix {
        pnpm-packages-src = config.globalNpmPackages.packagesSrc;
        pnpm-packages-deps-hash = config.globalNpmPackages.packagesHash;
      })
    ];
  };
}
