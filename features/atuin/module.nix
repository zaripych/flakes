{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.atuin ];

  programs.zsh.interactiveShellInit = ''
    eval "$(atuin init zsh)"
  '';

  programs.bash.interactiveShellInit = ''
    eval "$(atuin init bash)"
  '';
}
