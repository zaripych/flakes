{pkgs, ...}: {
  nixpkgs.overlays = [
    (import ./overlay.nix)
  ];

  environment.systemPackages = with pkgs; [
    nodejs
  ];
}
