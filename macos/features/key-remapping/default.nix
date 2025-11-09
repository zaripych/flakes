{pkgs ? import <nixpkgs> {}}: let
  deps = pkgs.buildNpmPackage {
    pname = "scripts-builder";
    version = "0.1.0";
    src = ./scripts;

    npmDeps = pkgs.importNpmLock {
      npmRoot = ./scripts;
    };

    npmConfigHook = pkgs.importNpmLock.npmConfigHook;
  };
  runScript = pkgs.writeShellScriptBin "run" ''
    ${pkgs.nodejs}/bin/node --import ${deps}/lib/node_modules/key-remapping-scripts/dist/exportAsGlobals.js -e "$@"
  '';
in
  runScript
