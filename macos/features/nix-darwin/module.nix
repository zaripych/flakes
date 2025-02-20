{ inputs, ... }: {
  system = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 5;
    # Set Git commit hash for darwin-version.
    configurationRevision = (inputs.nix-darwin.rev or inputs.nix-darwin.dirtyRev or null);
  };
}
