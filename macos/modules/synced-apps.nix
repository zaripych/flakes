{ pkgs
, config
, lib
, username
, ...
}:

with lib;

{
  options.environment.syncedApps = mkOption {
    type = types.listOf types.package;
    default = [ ];
    example = literalExpression "[ pkgs._1password-gui ]";
    description = ''
      The set of application packages to copy over to
      /Applications. This is useful for applications that
      cannot be installed via symlink or are not allowed to
      be run outside of /Applications.
    '';
  };

  config.system.build.syncedApps = pkgs.buildEnv {
    name = "synced-applications";
    paths = config.environment.syncedApps;
    pathsToLink = "/Applications";
  };

  config.system.activationScripts.extraActivation.text = lib.mkForce ''
    echo "setting up /Applications/Nix Apps (Synced)..." >&2
    applications="/Applications"
    nix_apps="$applications/Nix Apps (Synced)"

    if ! test -d "$nix_apps"; then
        mkdir -p "$nix_apps"
        chown ${username}: "$nix_apps"
        chmod u+w "$nix_apps"
    fi

    find ${config.system.build.syncedApps}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
            /usr/bin/rsync -a "$src" "$nix_apps"
        done
  '';
}
