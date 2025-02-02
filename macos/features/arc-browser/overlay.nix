final: prev:
{
  arc-browser = prev.callPackage ./default.nix {
    arc-browser = prev.arc-browser;
  };
}

