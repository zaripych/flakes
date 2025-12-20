{lib, ...}: {
  options = {
    outOfStoreLinks.enable = lib.mkEnableOption {
      type = lib.types.bool;
      default = true;
      description = ''
        This manages out-of-store links for the user's configuration that
        they want to maintain in the flake source directory.
      '';
    };

    outOfStoreLinks.sourceLocations = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = ''
        A dictionary of source locations for out-of-store links. The keys
        are the `self.outPath` values of the flake and the values are the
        absolute source path location.
      '';
      example = ''
        {
          "''${self.outPath}" = "/home/user/src/repo";
        }
      '';
    };

    outOfStoreLinks.links = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          flake = lib.mkOption {
            type = lib.types.raw;
            description = ''
              The flake the source location of which we want to
              lookup. The source location should be defined in
              `sourceLocations` option.
            '';
          };
          linkFrom = lib.mkOption {
            type = lib.types.str;
            description = ''
              A path to a directory or file inside the flake's source location
              that we want to link from.
            '';
          };
          conflictStrategy = lib.mkOption {
            type = lib.types.enum ["backup-and-overwrite-target" "backup-and-overwrite-source" "error-if-exists"];
            default = "backup-and-overwrite-target";
            description = ''
              Strategy to use when there is a conflict (i.e., when the target
              path already exists). The options are:

              - "backup-and-overwrite-target": Back up the existing target
                to a temporary location and overwrite it with the symlink.

              - "backup-and-overwrite-source": Back up the existing source
                to a temporary location and overwrite it with the target's
                current content.

              - "error-if-exists": Do not create the symlink and raise an
                error if the target path already exists.
            '';
          };
        };
      });
      default = {};
      description = ''
        A dictionary of out-of-store links to create. The keys are locations
        where the links should be created and the values are a pair of values:
        {
          flake = <flake>;
          linkFrom = <path inside flake source>;
        }
      '';
      example = ''
        {
          "/home/user/.config/some-app/config.json" = {
            flake = self;
            linkFrom = "configs/some-app/config.json";
          };
        }
      '';
    };
  };
}
