{ pkgs
, username
, useFeatureAt
, ...
}:
{
  imports = [
    (useFeatureAt ../home-manager/module.nix)
  ];

  environment.systemPackages = with pkgs; [
    git
    git-lfs
    # Used as core.editor
    vim
    # For easy auth with github
    gh
  ];

  home-manager.users.${username} = {
    programs.git = {
      enable = true;

      extraConfig = {
        push.autoSetupRemote = true;
        merge.conflictStyle = "diff3";
        core.editor = "vim";
        credential.helper = "osxkeychain";
      };
    };
  };
}
