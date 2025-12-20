{...}: {
  perSystem = {pkgs, ...}: {
    packages.skhd-zig = pkgs.callPackage ./skhd-zig-precompiled.nix {};
  };
}
