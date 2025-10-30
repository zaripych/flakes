{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../nixos-modules-compat/module.nix
    (toString (inputs.nixpkgs + "/nixos/modules") + "/programs/zsh/oh-my-zsh.nix")
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # These options are under programs.fzf on linux, so it's separate module
    enableFzfCompletion = true;
    enableFzfGit = true;
    enableFzfHistory = true;

    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "colorize"
      ];
      theme = "fino";
    };
  };

  environment.systemPackages = [
    pkgs.chroma
  ];
}
