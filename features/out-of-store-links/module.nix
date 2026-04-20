{
  inputs,
  config,
  lib,
  username,
  pkgs,
  ...
}: {
  imports = [./options.nix];

  config = lib.mkIf config.outOfStoreLinks.enable (let
    links =
      builtins.mapAttrs (linkTarget: linkSpec: let
        sourceLocation = config.outOfStoreLinks.sourceLocations."${linkSpec.flake.sourceInfo.narHash}";
        sourceFullPath = sourceLocation + "/" + linkSpec.linkFrom;
      in {
        sourceFullPath = sourceFullPath;
        conflictStrategy = linkSpec.conflictStrategy or "backup-and-overwrite-target";
      })
      config.outOfStoreLinks.links;
    data = builtins.toJSON links;
  in {
    home-manager.users."${username}".home.activation.createOutOfStoreLinks = inputs.home-manager.lib.hm.dag.entryAfter ["linkGeneration"] ''
      data='${data}';
      echo "$data" | ${lib.getExe pkgs.jq} -r 'to_entries[] | "\(.key)\t\(.value | .sourceFullPath)\t\(.value | .conflictStrategy)"' | while IFS=$'\t' read -r target source conflictStrategy; do
        # If the target already exists, but the source is not, copy the target to the source
        if [ -e "$target" ] && [ ! -e "$source" ]; then
          echo "Copying existing file $target to out-of-store location $source"
          mkdir -p "$(dirname "$source")"
          cp -R "$target" "$source"
        elif [ ! -e "$target" ] && [ ! -e "$source" ]; then
          echo "Neither target $target nor source $source exist, skipping link creation"
          continue
        else
          # If the target is not a symlink to the source, recreate it
          if [ ! -L "$target" ] || [ "$(readlink "$target")" != "$source" ]; then
            echo "Creating symlink from $target to out-of-store location $source"
            mkdir -p "$(dirname "$target")"

            temporary_dir=$(mktemp -d)

            if [ "$conflictStrategy" = "backup-and-overwrite-target" ] && [ -e "$target" ]; then
              echo "Backing up existing target $target to $temporary_dir/$(basename "$target")"
              cp -R "$target" "$temporary_dir/$(basename "$target")"
            elif [ "$conflictStrategy" = "backup-and-overwrite-source" ] && [ -e "$source" ]; then
              echo "Backing up existing source $source to $temporary_dir/$(basename "$source")"
              cp -R "$source" "$temporary_dir/$(basename "$source")"
              echo "Overwriting $source"
              cp -R "$target" "$source"
            elif [ "$conflictStrategy" = "error-if-exists" ] && [ -e "$target" ]; then
              echo "Error: Target $target exists and conflictStrategy is error-if-exists, aborting link creation"
              exit 1
            fi

            unlink "$target" 2>/dev/null || rm -rf "$target" 2>/dev/null
            ln -sfn "$source" "$target"
          fi
        fi
      done
    '';
  });
}
