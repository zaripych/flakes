{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.systemRefresh;
  git-add = lib.optionalString (builtins.length cfg.gitAddPaths > 0) (builtins.concatStringsSep "\n" (builtins.map (path: "git -C ${path} add .") cfg.gitAddPaths));
  refresh-inputs = lib.optionalString ((builtins.length cfg.updateInputs > 0) && cfg.flakePath != "") "nix flake update --flake ${cfg.flakePath} ${builtins.concatStringsSep " " cfg.updateInputs}";
  flake-arg = lib.optionalString (cfg.flakePath != "") "--flake ${cfg.flakePath}";
  command =
    if pkgs.stdenv.isDarwin
    then "darwin-rebuild"
    else "nixos-rebuild";
in {
  imports = [./options.nix];

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "system-refresh" ''
        # If arguments do not contain build or switch, we do not refresh inputs
        if [[ " $@ " =~ " build " ]] || [[ " $@ " =~ " switch " ]]; then
          ${git-add}
          ${refresh-inputs}
        fi
        # If arguments contain switch, then we must run as root
        SHOULD_RUN_AS_ROOT=$(
          if [[ " $@ " =~ " switch " ]]; then
            echo "1"
          else
            echo "0"
          fi
        )
        if [ "$SHOULD_RUN_AS_ROOT" -eq "1" ]; then
          sudo ${command} ${flake-arg} $@
        else
          ${command} ${flake-arg} $@
        fi
      '')
    ];
  };
}
