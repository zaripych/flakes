{ pkgs
, config
, lib
, inputs
, ...
}: {

  fonts = {
    packages = [
      pkgs.powerline-fonts
    ];
  };
}
