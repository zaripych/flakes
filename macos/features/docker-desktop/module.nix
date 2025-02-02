{ pkgs, ... }:
let
  docker-desktop = pkgs.callPackage ./default.nix { };
in
{
  environment.systemPackages = [
    docker-desktop
  ];
}
