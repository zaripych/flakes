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

      package = (import inputs.nixpkgs-unstable {system = pkgs.system;}).television;

      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    programs.nix-search-tv = {
      enable = true;

      enableTelevisionIntegration = true;
    };
  };
}
