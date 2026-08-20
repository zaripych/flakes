{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    pnpm
    bun
  ];

  # Allow pnpm to install to the home directory
  programs.zsh.shellInit = ''
    export PNPM_HOME="$HOME/.pnpm-home"
    export PATH="$PNPM_HOME/bin:$PATH"
  '';
}
