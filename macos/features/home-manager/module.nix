{ username
, inputs
, ...
}:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    {
      users.users.${username}.home = "/Users/${username}";

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      home-manager.sharedModules = [
        inputs.mac-app-utils.homeManagerModules.default
      ];

      home-manager.users.${username} = {
        home.username = username;
        home.stateVersion = "25.05";
      };

      home-manager.extraSpecialArgs = {
        inherit inputs;
        inherit username;
      };

      home-manager.backupFileExtension = "backup";
    }
  ];
}
