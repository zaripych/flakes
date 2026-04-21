{...}: {
  perSystem = {pkgs, ...}: {
    packages.aerospace-swipe = pkgs.callPackage ./default.nix {};
  };
}
