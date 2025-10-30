{ pkgs
, ...
}: {

  fonts = {
    packages = [
      pkgs.nerd-fonts.noto
      pkgs.nerd-fonts.meslo-lg
      pkgs.nerd-fonts.roboto-mono
      pkgs.nerd-fonts.profont
      pkgs.nerd-fonts.fira-code
    ];
  };
}
