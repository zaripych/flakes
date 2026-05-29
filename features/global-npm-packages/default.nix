{
  stdenv,
  lib,
  nodejs,
  pnpm_9,
  pnpmConfigHook,
  fetchPnpmDeps,
  src,
  hash ? "",
}: let
  packageJson = lib.importJSON "${src}/package.json";
  name = packageJson.name;
  version = packageJson.version + "-" + (builtins.substring 0 4 (builtins.hashFile "sha256" "${src}/package.json"));
in
  stdenv.mkDerivation (finalAttrs: {
    name = "global-npm-packages-${name}-${version}";
    pname = name;
    version = version;

    src = src;

    nativeBuildInputs = [
      nodejs
      pnpm_9
      pnpmConfigHook
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

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      pnpm = pnpm_9;
      fetcherVersion = 2;
      hash = hash;
    };
  })
