{...}: {
  imports = [
    ../global-npm-packages/module.nix
  ];

  globalNpmPackages = {
    enable = true;
    packages = [
      {
        src = ../npm-packages;
        hash = "sha256-RzPwgsS8GC3T7WzmGQGTNzlV8eIyI5RjstN6Us/FV+w=";
      }
    ];
  };
}
