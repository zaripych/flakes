{
  stdenv,
  fetchFromGitHub,
  zig_0_14,
  lib,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "skhd-zig";
  version = "0.0.15";

  src = fetchFromGitHub {
    owner = "jackielii";
    repo = "skhd.zig";
    rev = "v0.0.15";
    hash = "sha256-h3r0/y3EBFAAJ/FA5vH3f0HJq/82BhGP2k/YErVP93s="; # placeholder
  };

  preBuild = ''
    # We unset some NIX environment variables that might interfere with the zig
    # compiler.
    # Issue: https://github.com/ziglang/zig/issues/18998
    unset NIX_CFLAGS_COMPILE
    unset NIX_LDFLAGS
  '';

  postBuild = ''
    # Sign using ./scripts/codesign.sh
    /usr/bin/codesign -f -s "nix-apps-cert" -i "org.nixos.skhd" ./zig-out/bin/skhd
  '';

  zigBuildFlags = [
    "-Doptimize=ReleaseFast"
  ];

  nativeBuildInputs = [
    zig_0_14.hook
  ];

  meta = with lib; {
    description = "Simple hotkey daemon for macOS, rewritten in Zig";
    homepage = "https://github.com/jackielii/skhd.zig";
    license = licenses.mit;
    platforms = platforms.darwin;
  };
})
