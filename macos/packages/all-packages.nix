{ nixpkgs
}:

{
  _1password-gui =
    nixpkgs.callPackage ./1password-gui/default.nix { };
  docker-desktop =
    nixpkgs.callPackage ./docker-desktop/default.nix { };
  arc-browser =
    nixpkgs.callPackage ./arc-browser/default.nix { };
}
