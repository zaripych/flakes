{ fetchurl
, arc-browser
}:

arc-browser.overrideAttrs (oldAttrs: rec {
  version = "1.101.1-65021";
  src = fetchurl {
    url = "https://releases.arc.net/release/Arc-${version}.dmg";
    hash = "sha256-FBgfwM60ca1NQmUtaXKiQ6Rz0XXtertXZTJH0N8WvBY=";
  };
})
