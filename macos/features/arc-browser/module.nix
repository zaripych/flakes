{ pkgs, ... }:
let
  arc-browser = pkgs.callPackage ./default.nix { };
in
{
  environment.systemPackages = [
    arc-browser
  ];
}
