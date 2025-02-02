{ pkgs
, config
, lib
, inputs
, ...
}: {
  security.pam.enableSudoTouchIdAuth = true;
}
