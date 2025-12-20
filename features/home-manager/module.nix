{modulesPlatform, ...}: {
  imports = let
    module =
      if modulesPlatform == "x86_64-linux" || modulesPlatform == "aarch64-linux"
      then ./nixos.module.nix
      else if modulesPlatform == "x86_64-darwin" || modulesPlatform == "aarch64-darwin"
      then ./nix-darwin.module.nix
      else throw "Unsupported system: ${modulesPlatform}";
  in [
    module
  ];
}
