{ pkgs
, config
, lib
, inputs
, useFeatureAt
, ...
}: {
  imports = [
    (useFeatureAt ../../../../features/global-npm-packages/module.nix)
  ];

  globalNpmPackages = {
    enable = true;
    packagesSrc = (../npm-packages);
    packagesHash = "sha256-b4DyUQFNJiIUUUQRzMo3KUdFPoAt39n1aEG457GlCJM=";
  };
}
