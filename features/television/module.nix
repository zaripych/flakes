{
  inputs,
  pkgs,
  username,
  ...
}: {
  imports = [
    ../home-manager/module.nix
  ];

  home-manager.users.${username} = {
    programs.television = {
      enable = true;

      package = let
        nixpkgs =
          if !inputs ? nixpkgs-unstable || inputs.nixpkgs.sourceInfo == inputs.nixpkgs-unstable.sourceInfo
          then pkgs
          else (import inputs.nixpkgs-unstable {system = pkgs.system;});
      in
        nixpkgs.television;

      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    programs.nix-search-tv = {
      enable = true;

      enableTelevisionIntegration = true;
    };
  };
}
