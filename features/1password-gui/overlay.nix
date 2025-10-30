final: prev:
{
  _1password-gui = prev.callPackage ./default.nix {
    _1password-gui = prev._1password-gui;
  };
}

