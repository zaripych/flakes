{...}: {
  imports = [
    ../global-npm-packages/module.nix
  ];

  globalNpmPackages = {
    enable = true;
    packages = [
      {
        src = ../npm-packages;
        hash = "sha256-rbgE0r+DDVBCX8rhDh/9GWl6hyM8vC91/crJqRil11M=";
      }
    ];
  };
}
