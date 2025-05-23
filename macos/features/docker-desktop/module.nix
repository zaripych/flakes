{ pkgs, useFeatureAt, ... }:
let
  docker-desktop = pkgs.callPackage ./default.nix { };
in
{
  imports = [
    (useFeatureAt ../synced-applications/module.nix)
  ];

  environment.syncedApps = [
    docker-desktop
  ];
}
