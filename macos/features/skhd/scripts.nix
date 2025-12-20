{
  buildNpmPackage,
  importNpmLock,
  writeShellScriptBin,
  nodejs,
  ...
}: let
  deps = buildNpmPackage {
    pname = "skhd-scripts";
    version = "0.1.0";
    src = ./scripts;

    npmDeps = importNpmLock {
      npmRoot = ./scripts;
    };

    npmConfigHook = importNpmLock.npmConfigHook;
  };
in
  writeShellScriptBin "skhd-scripts" ''
    TMPDIR=/tmp
    # echo "$@" >> $TMPDIR/key-remapping-output.txt
    # ${nodejs}/bin/node --import ${deps}/lib/node_modules/key-remapping-scripts/dist/exportAsGlobals.js -e "$@" >> $TMPDIR/key-remapping-output.txt 2>> $TMPDIR/key-remapping-error.txt
    ${nodejs}/bin/node --import ${deps}/lib/node_modules/key-remapping-scripts/dist/exportAsGlobals.js -e "$@"
  ''
