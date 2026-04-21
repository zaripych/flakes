{
  stdenv,
  fetchFromGitHub,
  darwin,
}: let
  version = "976c3107f6ed9859149bdc130e3f8928f2ab6852";
in
  stdenv.mkDerivation {
    pname = "aerospace-swipe";
    inherit version;

    src = fetchFromGitHub {
      owner = "acsandmann";
      repo = "aerospace-swipe";
      rev = version;
      hash = "sha256-ARJfYiWXBCvXA5JlFl/s4VIQ9xuqBoU3gPfC8B2mkWI=";
    };

    nativeBuildInputs = [darwin.sigtool];

    buildPhase = ''
      runHook preBuild
      make swipe
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dm755 swipe $out/bin/swipe
      codesign --force --entitlements accessibility.entitlements --sign - $out/bin/swipe
      runHook postInstall
    '';

    dontFixup = true;
  }
