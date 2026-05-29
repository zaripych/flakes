{
  inputs,
  pkgs,
  username,
  ...
}: let
  neovim = inputs.self.packages."${pkgs.stdenv.hostPlatform.system}".neovim;
  nvim = "${neovim}/bin/nvim";
in {
  environment.variables = {
    EDITOR = nvim;
    VISUAL = nvim;
  };

  home-manager.users."${username}".home = {
    packages = [neovim];
    sessionVariables = {
      EDITOR = nvim;
      VISUAL = nvim;
    };
  };
}
