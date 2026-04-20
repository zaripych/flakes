{
  inputs,
  pkgs,
  username,
  config,
  ...
}: {
  home-manager.users."${username}".home.packages = [
    (inputs.self.packages."${pkgs.stdenv.hostPlatform.system}".neovim)
  ];
}
