{ lib
, stdenvNoCC
, fetchurl
, undmg
}:

stdenvNoCC.mkDerivation
  (finalAttrs: {
    pname = "docker-desktop";
    version = "4.38.0";

    src = fetchurl {
      # Releases https://docs.docker.com/desktop/release-notes/
      url = "https://desktop.docker.com/mac/main/arm64/181591/Docker.dmg";
      hash = "sha256-Kf5ALVpk2GVlrkrWnxkVizxNcQwsz8bh/rDSEjmiFJ4=";
    };

    nativeBuildInputs = [ undmg ];

    sourceRoot = "Docker.app";

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications/Docker.app"
      cp -R . "$out/Applications/Docker.app"

      runHook postInstall
    '';

    dontFixup = true;

    meta = {
      description = "Docker Desktop";
      homepage = "https://docs.docker.com/desktop";
      license = lib.licenses.unfree;
      maintainers = with lib.maintainers; [ donteatoreo ];
      platforms = [
        "aarch64-darwin"
      ];
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  })
