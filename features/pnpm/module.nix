{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nodePackages.pnpm
  ];

  # Allow pnpm to install to the home directory
  programs.zsh.shellInit = ''
    export PNPM_HOME=~/.pnpm-home
    export PATH=~/.pnpm-home:$PATH
  '';
}
