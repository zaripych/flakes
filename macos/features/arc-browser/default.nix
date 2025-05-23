{ fetchurl
, arc-browser
}:

arc-browser.overrideAttrs (oldAttrs: rec {
  version = "1.95.0-62781";
  src = fetchurl {
    url = "https://releases.arc.net/release/Arc-${version}.dmg";
    hash = "sha256-ZYwd6/CPPINcIt83HD2nqH8ozLYLwfeNDBm0VKP5NIU=";
  };
})
