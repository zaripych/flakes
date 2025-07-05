{ lib
, stdenvNoCC
, fetchurl
, undmg
}:

stdenvNoCC.mkDerivation
  (finalAttrs: {
    pname = "docker-desktop";
    version = "4.41.2";

    src = fetchurl {
      # Releases https://docs.docker.com/desktop/release-notes/
      url = "https://desktop.docker.com/mac/main/arm64/198352/Docker.dmg";
      hash = "sha256-zPCO9gOnz5Nf8S9I/oN5PIjcQD/grjMU1vPTrg3Jni8=";
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
