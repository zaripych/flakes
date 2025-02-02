{ pkgs
, config
, lib
, inputs
, useFeatureAt
, ...
}: {

  imports = [
    (useFeatureAt ./features/basic-tools/module.nix)
    (useFeatureAt ./features/app-store-apps/module.nix)

    (useFeatureAt ../../features/1password-gui/module.nix)
    (useFeatureAt ../../features/docker-desktop/module.nix)
    (useFeatureAt ../../features/arc-browser/module.nix)

    (useFeatureAt ./features/vscode/module.nix)
    (useFeatureAt ./features/npm-packages/module.nix)
  ];
}
