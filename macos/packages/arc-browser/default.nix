{ lib
, fetchurl
, arc-browser
}:

arc-browser.overrideAttrs (oldAttrs: rec {
  version = "1.74.0-57065";
  src = fetchurl {
    url = "https://releases.arc.net/release/Arc-${version}.dmg";
    hash = "sha256-muTTHJOQKY/oqGJ4OXgoyOhgAo0hW6Y12Dknq/KWTMw=";
  };
})
