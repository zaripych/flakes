{ pkgs
, config
, lib
, inputs
, ...
}: {
  programs = {
    direnv = {
      enable = true;
    };
  };
}
