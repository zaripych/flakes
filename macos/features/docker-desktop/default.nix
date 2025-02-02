{ lib
, stdenvNoCC
, fetchurl
, undmg
}:

stdenvNoCC.mkDerivation
  (finalAttrs: {
    pname = "docker-desktop";
    version = "4.37.1";

    src = fetchurl {
      # Releases https://docs.docker.com/desktop/release-notes/
      url = "https://desktop.docker.com/mac/main/arm64/178610/Docker.dmg";
      hash = "sha256-Rx96W9Z4dUV6SA7cPVI0Y1odO3w7FY/apSDIhyPjJxI=";
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
