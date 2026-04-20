{
  stdenvNoCC,
  fetchurl,
  lib,
  ...
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "skhd-zig";
  version = "0.0.17";

  src = fetchurl {
    url = "https://github.com/jackielii/skhd.zig/releases/download/v${finalAttrs.version}/skhd-arm64-macos.tar.gz";
    hash = "sha256-1lvvQoUOCxpus07L5KsG1l30GI+LP+KkvLGQN12KFhs=";
  };

  sourceRoot = ".";

  dontBuild = true;

  # Don't fixup the app, we don't want to break the code signatures
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp skhd-arm64-macos $out/bin/skhd
    runHook postInstall
  '';

  meta = with lib; {
    description = "Simple hotkey daemon for macOS, rewritten in Zig";
    homepage = "https://github.com/jackielii/skhd.zig";
    license = licenses.mit;
    platforms = ["aarch64-darwin"];
  };
})
