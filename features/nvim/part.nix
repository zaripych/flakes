{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    packages.neovim =
      (inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [./configuration.nix];
      }).neovim;
  };
}
