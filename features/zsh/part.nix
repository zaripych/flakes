{...}: {
  # imports = let
  #   module =
  #     if system == "x86_64-linux" || system == "aarch64-linux"
  #     then ./nixos.module.nix
  #     else if system == "x86_64-darwin" || system == "aarch64-darwin"
  #     then ./nix-darwin.module.nix
  #     else throw "Unsupported system: ${system}";
  # in [
  #   module
  # ];

  flake.nixosModules.zsh = ./nixos.module.nix;
  flake.darwinModules.zsh = ./nix-darwin.module.nix;
}
