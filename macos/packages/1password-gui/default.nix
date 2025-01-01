{ lib
, fetchurl
, _1password-gui
}:

_1password-gui.overrideAttrs (oldAttrs: rec {
  version = "8.10.56";
  src = fetchurl {
    url = "https://downloads.1password.com/mac/1Password-${version}-aarch64.zip";
    hash = "sha256-byu8SW/GVvKBDN02BblziRzo4QG00k7tuC5Bb5BpqtU=";
  };
  meta = oldAttrs.meta // {
    broken = false;
  };
})
