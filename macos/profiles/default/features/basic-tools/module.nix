{ pkgs
, config
, lib
, inputs
, ...
}: {

  environment.systemPackages = with pkgs; [
    git
    git-lfs
    jq
    fzf
    nodejs
    nodePackages.pnpm

    haskellPackages.patat

    gh

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
