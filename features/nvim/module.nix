{inputs, ...}: {
  imports = [
    inputs.nvf.nixosModules.default
  ];

  programs.nvf = {
    enable = true;

    settings = import ./configuration.nix;
  };
}
