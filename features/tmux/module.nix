{
  inputs,
  username,
  ...
}: {
  imports = [
    ../home-manager/module.nix
  ];

  home-manager.users.${username} = {
    lib,
    pkgs,
    ...
  }: {
    imports = [
      inputs.tmux-which-key.homeManagerModules.default
    ];

    programs.tmux = {
      enable = true;

      tmux-which-key = {
        enable = true;

        # The default config only binds `prefix + Space`; `root_table` is
        # commented out upstream. Extend the default settings to also bind
        # Ctrl+Space without a prefix.
        settings = let
          defaultSettings = import "${inputs.tmux-which-key}/nix/generate-config.nix" {
            inherit lib pkgs;
          };
        in
          defaultSettings
          // {
            keybindings = defaultSettings.keybindings // {root_table = "C-Space";};
          };

        # The upstream plugin script uses GNU-only `realpath --relative-to`,
        # which fails with macOS BSD realpath and aborts before loading the
        # plugin. Patch it to use GNU realpath from coreutils directly.
        package = inputs.tmux-which-key.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
          postInstall =
            (old.postInstall or "")
            + ''
              substituteInPlace $out/share/tmux-plugins/tmux-which-key/plugin.sh.tmux \
                --replace-fail 'realpath --relative-to' '${pkgs.coreutils}/bin/realpath --relative-to'
            '';
        });
      };
    };
  };
}
