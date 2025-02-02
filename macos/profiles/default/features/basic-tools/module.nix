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
    _1password-cli

    iterm2
    haskellPackages.patat
  ];
}
