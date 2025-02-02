{ pkgs, useFeatureAt, ... }: {

  imports = [
    (useFeatureAt ../synced-applications/module.nix)
  ];

  environment.syncedApps = [
    (pkgs.callPackage ./default.nix {
      _1password-gui = pkgs._1password-gui;
    })
  ];
}
