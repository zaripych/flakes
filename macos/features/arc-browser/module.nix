{ pkgs, useFeatureAt, ... }:
let
  arc-browser = pkgs.callPackage ./default.nix { };
in
{
  imports = [
    (useFeatureAt ../synced-applications/module.nix)
  ];

  environment.syncedApps = [
    arc-browser
  ];
}
