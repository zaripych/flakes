{ pkgs
, nixpkgsModulesPath
, useFeatureAt
, flakePath
, ...
}: {

  # This imports oh-my-zsh module from nixpkgs
  imports = [
    # NOTE: This requires `nixos-modules-compat` module to work in nix-darwin
    (useFeatureAt ../nixos-modules-compat/module.nix)
    # Hack out the nixos oh-my-zsh module from nixpkgs
    (nixpkgsModulesPath + "/programs/zsh/oh-my-zsh.nix")
  ];

  environment.systemPackages = [
    # Used by colorize plugin below
    pkgs.chroma
  ];

  programs = {

    zsh = {
      enable = true;
      enableCompletion = true;

      enableFzfCompletion = true;
      enableFzfGit = true;
      enableFzfHistory = true;

      enableFastSyntaxHighlighting = false;

      ohMyZsh = {
        enable = true;
        plugins = [
          "git"
          "colorize"
        ];
        theme = "fino";
      };

      shellInit = ''
        # A shortcut to refresh the nix-darwin configuration
        function darwin-refresh() {
          darwin-rebuild switch --flake ${flakePath} --print-build-logs $@
        }
      '';
    };
  };

}
