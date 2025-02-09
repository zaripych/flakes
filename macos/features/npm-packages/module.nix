{ useFeatureAt
, ...
}: {
  imports = [
    (useFeatureAt ../global-npm-packages/module.nix)
  ];

  globalNpmPackages = {
    enable = true;
    packages = [
      {
        src = ../npm-packages;
        hash = "sha256-qAC/6s58A75zFJKTv2VeWdORx+GRCt2fZL+7lA60dV4=";
      }
    ];
  };
}
