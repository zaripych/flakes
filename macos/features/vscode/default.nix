{ fetchurl
, vscode
}:
let
  plat = "darwin-arm64";
  archive_fmt = "zip";
  sha256 = "TODO";
in

vscode.overrideAttrs (oldAttrs: rec {
  version = "TODO";
  src = fetchurl {
    # as per https://github.com/NixOS/nixpkgs/blob/95e145c44b51ad89c8f93c1fa84e021bb67b86d8/pkgs/applications/editors/vscode/vscode.nix#L62
    name = "VSCode_${version}_${plat}.${archive_fmt}";
    url = "https://update.code.visualstudio.com/${version}/${plat}/stable";
    inherit sha256;
  };
})
