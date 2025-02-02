# Was grabbed from here https://discourse.nixos.org/t/apply-a-patch-to-an-input-flake/36904
# this allows us to apply patches to an arbitrary flake input and also "lock" the flake inputs
# to follow overridden lockFileEntries - a small modification was made as it seems call-flake.nix
# was modified since posting and now requires { root = { sourceInfo = src; subdir = ""; }; } to be passed
# as the second argument to succeed.
{ lib }:

{ pkgs
, name
, src
, patches
, lockFileEntries ? { }
}:
let
  numOfPatches = lib.length patches;

  patchedFlake =
    let
      patched = (pkgs.applyPatches {
        inherit name src;
        patches = map pkgs.fetchpatch2 patches;
      }).overrideAttrs (_: prevAttrs: {
        outputs = [ "out" "narHash" ];
        installPhase = lib.concatStringsSep "\n" [
          prevAttrs.installPhase
          ''
            ${lib.getExe pkgs.nix} \
              --extra-experimental-features nix-command \
              --offline \
              hash path ./ \
              > $narHash
          ''
        ];
      });

      lockFilePath = "${patched.outPath}/flake.lock";

      lockFile = builtins.unsafeDiscardStringContext (lib.generators.toJSON { } (
        if lib.pathExists lockFilePath
        then
          let
            original = lib.importJSON lockFilePath;
          in
          {
            inherit (original) root;
            nodes = original.nodes // lockFileEntries;
          }
        else {
          nodes.root = { };
          root = "root";
        }
      ));

      flake = {
        inherit (patched) outPath;
        narHash = lib.fileContents patched.narHash;
      };
    in
    (import ./call-flake/call-flake.nix) lockFile ({ root = { sourceInfo = flake; subdir = ""; }; });
in
if numOfPatches == 0
then
  lib.trace "applyPatches: skipping ${name}, no patches" src
else
  lib.trace "applyPatches: creating ${name}, number of patches: ${toString numOfPatches}" patchedFlake

