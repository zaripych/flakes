{ pkgs
, ...
}: {

  environment.systemPackages = with pkgs; [
    jq
    fzf
    nodejs

    haskellPackages.patat

    _1password-cli
  ];

  environment.syncedApps = with pkgs; [
    iterm2
  ];

  # Allow pnpm to install to the home directory
  programs.zsh.shellInit = ''
    export PNPM_HOME=~/.pnpm-home
    export PATH=~/.pnpm-home:$PATH
  '';
}
