{ fetchurl
, arc-browser
}:

arc-browser.overrideAttrs (oldAttrs: rec {
  version = "1.79.1-58230";
  src = fetchurl {
    url = "https://releases.arc.net/release/Arc-${version}.dmg";
    hash = "sha256-BYlKiDcgVviKeKI++qjTALRblI+kFNq7gm5EFmaa3sM=";
  };
})
