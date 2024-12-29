{ stdenv
, lib
, nodejs
, pnpm
, pnpm-packages-src
, pnpm-packages-deps-hash ? ""
}:
let
  fs = lib.fileset;
in
stdenv.mkDerivation (finalAttrs: {
  name = "global-npm-packages";
  pname = "global-npm-packages";
  version = "0.0.0";

  src = pnpm-packages-src;

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];

  buildPhase = ''
    runHook preBuild
    echo $pnpmDeps
    # Optionally run a build script here
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    cp -r . $out

    # ls binaries from node_modules/.bin
    mkdir -p $out/bin
    for bin in $(ls $out/node_modules/.bin); do
      ln -s $out/node_modules/.bin/$bin $out/bin/$bin
    done

    # Patch the $basedir expression in each bin script using awk
    for bin in $(ls $out/bin); do
      awk -i inplace -v basedir=$out/node_modules/.bin '{
        gsub(/\$basedir/, basedir);
        print $0;
      }' $out/bin/$bin
    done

    echo "Finished installing global npm packages at $out"

    runHook postInstall
  '';

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = pnpm-packages-deps-hash;
  };
})
