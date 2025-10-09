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
        hash = "sha256-3Fz1tJxxFvybZs9BqIOFsS5OAW2VW4LZtNU0P1GTZmQ=";
      }
    ];
  };
}
