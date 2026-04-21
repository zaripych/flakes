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
    links."/Users/${username}/Library/Application Support/Leader Key" = {
      flake = inputs.self;
      linkFrom = "macos/features/leader-key/config/";
      # conflictStrategy = "backup-and-overwrite-source";
    };
  };
}
