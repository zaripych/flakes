{ useFeatureAt
, ...
}: {

  imports = [
    # Inherit from the minimal profile
    (useFeatureAt ../minimal/module.nix)

    (useFeatureAt ../../features/basic-tools/module.nix)
    (useFeatureAt ../../features/nodejs-version/module.nix)
    (useFeatureAt ../../features/pnpm/module.nix)
    # AppStore apps require homebrew to be pre-installed
    (useFeatureAt ../../features/app-store-apps/module.nix)
    (useFeatureAt ../../features/vscode/module.nix)
    (useFeatureAt ../../features/npm-packages/module.nix)

    (useFeatureAt ../../features/1password-gui/module.nix)
    (useFeatureAt ../../features/docker-desktop/module.nix)
  ];
}
