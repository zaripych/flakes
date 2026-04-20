{...}: {
  imports = [
    ../global-npm-packages/module.nix
  ];

  globalNpmPackages = {
    enable = true;
    packages = [
      {
        src = ../npm-packages;
        hash = "sha256-UnHMaGcWb6X3yVYUxu/jlGKnQ1bd3MLw/MySa95bKRI=";
      }
    ];
  };
}
