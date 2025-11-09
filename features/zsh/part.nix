{...}: {
  flake.nixosModules.zsh = ./nixos.module.nix;
  flake.darwinModules.zsh = ./nix-darwin.module.nix;
}
