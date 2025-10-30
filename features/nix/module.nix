{pkgs, ...}: {
  # Auto upgrade nix package and the daemon service.
  nix.enable = true;
  nix.package = pkgs.nix;

  nixpkgs.config.allowUnfree = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  environment.systemPackages = with pkgs; [
    nil
    alejandra
    nix-search-cli
    nix-tree
  ];
}
