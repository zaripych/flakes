{ pkgs, useFeatureAt, ... }: {

  imports = [
    (useFeatureAt ../synced-applications/module.nix)
    {
      nixpkgs.config = {
        allowUnfree = true;
      };
    }
  ];

  environment.syncedApps = [
    (pkgs.callPackage ./default.nix {
      _1password-gui = pkgs._1password-gui;
    })
  ];
}
