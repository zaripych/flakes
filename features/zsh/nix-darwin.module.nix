{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../nixos-modules-compat/module.nix
    (toString (inputs.nixpkgs + "/nixos/modules") + "/programs/zsh/oh-my-zsh.nix")
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # These options are under programs.fzf on linux, so it's separate module
    enableFzfCompletion = true;
    # enableFzfGit = true;
    # enableFzfHistory = true;

    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "colorize"
      ];
      theme = "fino";
    };

    interactiveShellInit = ''
      # History configuration
      HISTSIZE=10000
      SAVEHIST=10000
      HISTFILE="$HOME/.zsh_history"

      # Don't record duplicate commands in history
      setopt HIST_IGNORE_DUPS       # Don't record an event that was just recorded again
      setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded entry if new entry is a duplicate
      setopt HIST_FIND_NO_DUPS      # Do not display duplicates when searching
      setopt HIST_SAVE_NO_DUPS      # Don't write duplicate entries in the history file
      setopt SHARE_HISTORY          # Share history between all sessions
    '';
  };

  environment.systemPackages = [
    pkgs.chroma
    pkgs.fzf
  ];
}
