{ lib
, stdenvNoCC
, fetchurl
, undmg
}:

stdenvNoCC.mkDerivation
  (finalAttrs: {
    pname = "docker-desktop";
    version = "4.47.0-206054";

    src = fetchurl {
      # Releases https://docs.docker.com/desktop/release-notes/
      url = "https://desktop.docker.com/mac/main/arm64/206054/Docker.dmg";
      hash = "sha256-eGg/ooT427EmKPiUM2XGfjm9g7DHaxQwoYCfFOaMvG4=";
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
