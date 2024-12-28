{ pkgs ? import <nixpkgs> { } }:
pkgs.stdenv.mkDerivation {
  name = "docker-desktop";
  src = pkgs.fetchurl {
    # Releases https://docs.docker.com/desktop/release-notes/
    url = "https://desktop.docker.com/mac/main/arm64/178610/Docker.dmg";
    hash = "sha256-Rx96W9Z4dUV6SA7cPVI0Y1odO3w7FY/apSDIhyPjJxI=";
  };
  nativeBuildInputs = [ ];
  unpackPhase = ''
    # We do not unpack the .dmg file, because that would
    # change the timestamps of the .app files inside it and
    # introduce issues with code-signed applications.
    #
    # We will use the .dmg file later to copy the .app's
    # to the Applications directory to install them, which
    # is going to happen in `dmg-apps.nix` module outside
    # of the regular Nix build process.
    #
  '';
  installPhase = ''
    # Just copy the .dmg file to the output directory
    mkdir -p "$out/Dmg/"
    name=$(echo $(basename "$src") | sed 's/^[^-]*-//')
    echo "Copying $src to $out/Dmg/$name"
    cp "$src" "$out/Dmg/$name"
  '';
}
