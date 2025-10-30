{
  pkgs,
  config,
  lib,
  username,
  ...
}:
with lib; {
  # meta.doc = ''
  #   This module copies over applications to /Applications that
  #   cannot be installed via symlink or are not allowed to be
  #   run outside of /Applications.

  #   One of such applications is 1Password, which requires to be
  #   installed in /Applications to start.
  # '';

  options.environment.syncedApps = mkOption {
    type = types.listOf types.package;
    default = [];
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
    echo "setting up /Applications" >&2
    applications="/Applications"
    nix_apps="$applications"

    # if ! test -d "$nix_apps"; then
    #     mkdir -p "$nix_apps"
    #     chown ${username}: "$nix_apps"
    #     chmod u+w "$nix_apps"
    # else
    #     chown ${username}: "$nix_apps"
    # fi

    find ${config.system.build.syncedApps}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
            # Read the date of the target .app directory
            # to determine if it has been updated, if it
            # has not been updated, then it will be 1 second
            # since epoch (1970-01-01 10:00:01) because
            # and we can skip copying it over.
            # We want to allow the user to update the application
            # which was copied over using the application itself.
            # --
            app_name=$(basename "$src")
            target_path="$nix_apps/$app_name"
            exists=$(test -d "$target_path" && echo "true" || echo "false")
            if [ "$exists" = "true" ]; then
                seconds_since_epoch=$(stat -c "%Y" "$target_path")
            else
                seconds_since_epoch="0"
            fi
            if [ "$exists" = "false" ] || [ "$seconds_since_epoch" = "1" ]; then
                echo "Copying $src to $nix_apps" >&2
                /usr/bin/rsync -a -c "$src" "$nix_apps"
                chown -R ${username}: "$target_path"
            else
                echo "Skipping $src as it seem to have been updated" >&2
            fi
        done
  '';
}
