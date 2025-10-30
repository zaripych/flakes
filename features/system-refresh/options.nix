{lib, ...}: {
  options = {
    systemRefresh.enable = lib.mkEnableOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Adds `system-refresh` command to the system which runs `darwin-rebuild`
        or `nixos-rebuild against the repository containing the `flake.nix` file
        and allows to automatically update a list of flake inputs.

        This eliminates the need to manually run `nix flake update` and then
        `darwin-rebuild` (or `nixos-rebuild`) with a path to the flake every
        time you want to update the system.
      '';
    };

    systemRefresh.flakePath = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        Path to the flake to run `*-rebuild` against. The path
        must stay the same across multiple hosts, if the configuration is used
        on multiple hosts.
      '';
    };

    systemRefresh.updateInputs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = ''
        List of flake inputs to update every time before running `darwin-rebuild`.
      '';
    };

    systemRefresh.gitAddPaths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = ''
        List of paths where we want to execute `git add .` to ensure `nix` picks
        up the changes. This is useful when we have a flake input that is a git
        repository, but you didn't commit/staged the changes yet.
      '';
    };
  };
}
