{
  username,
  inputs,
  ...
}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  users.users.${username}.home = "/Users/${username}";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    sharedModules = [
      inputs.mac-app-utils.homeManagerModules.default
    ];

    users.${username} = {
      home.username = username;
      home.stateVersion = "25.05";
    };

    extraSpecialArgs = {
      inherit inputs;
      inherit username;
    };

    backupFileExtension = "backup";
  };
}
