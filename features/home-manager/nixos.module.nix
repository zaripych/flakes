{
  username,
  inputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.${username} = {
      home.username = username;
      home.stateVersion = "25.05";
      home.homeDirectory = "/home/${username}";

      programs.home-manager.enable = true;
    };

    extraSpecialArgs = {
      inherit inputs;
      inherit username;
    };

    backupFileExtension = "backup";
  };
}
