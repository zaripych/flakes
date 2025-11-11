{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "colorize"
      ];
      theme = "fino";
    };
  };

  programs.fzf = {
    fuzzyCompletion = true;
    # keybindings = true;
  };

  environment.systemPackages = [
    pkgs.chroma
  ];
}
