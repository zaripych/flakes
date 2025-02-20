{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.darwinRefresh;
in
{
  options = {
    darwinRefresh.enable = lib.mkEnableOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Adds `darwin-refresh` command to the system which runs `darwin-rebuild`
        against the repository containing the `flake.nix` file and allows to
        automatically update a list of flake inputs.

        This eliminates the need to manually run `nix flake update` and then
        `darwin-rebuild` with a path to the flake every time you want to update
        the system.
      '';
    };

    darwinRefresh.flakePath = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        Path to the flake to run `darwin-rebuild` against. The path
        must stay the same across multiple hosts, if the configuration is used
        on multiple hosts.
      '';
    };

    darwinRefresh.updateInputs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        List of flake inputs to update every time before running `darwin-rebuild`.
      '';
    };

    darwinRefresh.gitAddPaths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        List of paths where we want to execute `git add .` to ensure `nix` picks
        up the changes. This is useful when we have a flake input that is a git
        repository, but you didn't commit/staged the changes yet.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.flakePath != "";
        message = "Please specify darwinRefresh.flakePath option to use darwin-refresh feature.";
      }
    ];

    environment.systemPackages = [
      (
        let
          git-add =
            if builtins.length cfg.gitAddPaths > 0 then
              (builtins.concatStringsSep "\n" (builtins.map (path: "git -C ${path} add .") cfg.gitAddPaths))
            else "";
          refresh-inputs =
            if builtins.length cfg.updateInputs > 0 then
              ("nix flake update --flake ${cfg.flakePath} ${builtins.concatStringsSep " " cfg.updateInputs}")
            else "";
        in
        (pkgs.writeShellScriptBin "darwin-refresh" ''
          ${git-add}
          ${refresh-inputs}
          darwin-rebuild switch --flake ${cfg.flakePath} --print-build-logs $@
        '')
      )
    ];
  };

}
