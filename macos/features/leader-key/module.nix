{
  username,
  inputs,
  ...
}: {
  homebrew = {
    casks = [
      "leader-key"
    ];
  };

  outOfStoreLinks = {
    links."/Users/${username}/Library/Application Support/Leader Key/config.json" = {
      flake = inputs.self;
      linkFrom = "macos/features/leader-key/config.json";
      # conflictStrategy = "backup-and-overwrite-source";
    };
  };
}
