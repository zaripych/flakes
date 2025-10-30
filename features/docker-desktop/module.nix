{pkgs, ...}: let
  docker-desktop = pkgs.callPackage ./default.nix {};
in {
  imports = [
    ../synced-applications/module.nix
  ];

  environment.syncedApps = [
    docker-desktop
  ];
}
