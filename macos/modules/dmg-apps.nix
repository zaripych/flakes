{ pkgs
, config
, lib
, username
, ...
}:

{
  # Determine a list of systemPackages that have /Dmg directory
  system.build.dmg = pkgs.buildEnv {
    name = "dmg";
    paths = config.environment.systemPackages;
    pathsToLink = "/Dmg";
  };

  # Nix-darwin cannot install apps or dmg files, so we need to do it manually
  system.activationScripts.dmg.text = lib.mkForce ''
    echo "setting up ~/Applications..." >&2
    applications="/Users/${username}/Applications"
    nix_apps="$applications/Nix Apps"

    if ! test -d "$applications"; then
        mkdir -p "$applications"
        chown ${username}: "$applications"
        chmod u+w "$applications"
    fi

    mkdir -p "$nix_apps"

    find ${config.system.build.dmg}/Dmg -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
            echo "Installing $src to $nix_apps"

            dmg_filename=$(basename "$src")
            dmg_mounted_volume_name=''${dmg_filename/\.dmg/}
            
            echo "Mounting /Volumes/$dmg_mounted_volume_name"
            /usr/bin/hdiutil attach -noverify "$src"

            app_directory_path=$(find /Volumes/"$dmg_mounted_volume_name" -maxdepth 1 -type d -name "*.app" | head -n 1)
            if [ -z "$app_directory_path" ]; then
                echo "No app directory found in /Volumes/$dmg_mounted_volume_name"
                /usr/bin/hdiutil detach /Volumes/"$dmg_mounted_volume_name"
                continue;
            fi

            if [ -d "$nix_apps/$(basename "$app_directory_path")" ]; then
                echo "App $dmg_mounted_volume_name already installed, skipping"
                /usr/bin/hdiutil detach /Volumes/"$dmg_mounted_volume_name"
                continue;
            fi

            echo /usr/bin/rsync -a "$app_directory_path" "$nix_apps"
            /usr/bin/rsync -a "$app_directory_path" "$nix_apps"
            /usr/bin/hdiutil detach /Volumes/"$dmg_mounted_volume_name"
        done
  '';
}
