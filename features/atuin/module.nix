{pkgs, ...}: {
  environment.systemPackages = [pkgs.atuin];

  programs.zsh.interactiveShellInit = ''
    eval "$(atuin init zsh --disable-up-arrow)"
  '';

  programs.bash.interactiveShellInit = ''
    eval "$(atuin init bash --disable-up-arrow)"
  '';
}
