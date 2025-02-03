{ fetchurl, _1password-gui, ... }:

_1password-gui.overrideAttrs (oldAttrs: rec {
  version = "8.10.58";
  src = fetchurl {
    url = "https://downloads.1password.com/mac/1Password-${version}-aarch64.zip";
    hash = "sha256-7SczaIcY/bQtTy6ODQh464/14q+VvgnJr7EdhEzevCs=";
  };

  # Don't fixup the app, we don't want to break the code signatures
  dontFixup = true;

  meta = oldAttrs.meta // {
    # Since 1Password GUI doesn't work when symlinked via nix-darwin the package
    # was considered broken, but it works fine when the app is copied to /Applications
    # so we mark it as not broken. We use `synced-applications` module to copy the app.
    broken = false;
  };
})

