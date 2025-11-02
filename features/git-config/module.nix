{
  lib,
  pkgs,
  username,
  ...
}: {
  imports = [
    ../home-manager/module.nix
  ];

  environment.systemPackages = with pkgs; [
    git
    git-lfs
    # For easy auth with github
    gh
  ];

  home-manager.users.${username} = {
    programs.git = {
      enable = true;

      settings = {
        push.autoSetupRemote = true;
        merge.conflictStyle = "diff3";
        core.editor = "nvim";
        credential.helper = lib.optionalString (pkgs.system == "aarch64-darwin") "osxkeychain";
      };
    };
  };
}
