{
  inputs,
  config,
  ...
}: {
  flake.nvfConfiguration = import ./configuration.nix;

  flake.nixosModules.nvim = ./module.nix;

  perSystem = {pkgs, ...}: {
    packages.nvim =
      (inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [config.flake.nvfConfiguration];
      }).neovim;
  };
}
