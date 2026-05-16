{
  lib,
  pkgs,
  inputs,
  username,
  config,
  ...
}: {
  imports = [
    ../home-manager/module.nix
    {
      nixpkgs.overlays = [
        inputs.nix-vscode-extensions.overlays.default
      ];
    }
  ];

  options = {
    features.vscode.extensions = lib.mkOption {
      type =
        lib.types.raw
        // {
          merge = loc: defs: builtins.map (d: d.value) defs;
        };
      default = [];
      description = ''
        List of functions to select vscode extensions to install
        from the vscode marketplace. Each function takes
        one argument, the vscode-marketplace package set.
      '';
    };
  };

  config = {
    outOfStoreLinks.links = let
      vscodeUserDir = "/Users/${username}/Library/Application Support/Code/User";
    in {
      "${vscodeUserDir}/settings.json" = {
        flake = inputs.self;
        linkFrom = "features/vscode/vscode-profiles/settings.json";
      };
      "${vscodeUserDir}/keybindings.json" = {
        flake = inputs.self;
        linkFrom = "features/vscode/vscode-profiles/keybindings.json";
      };
    };

    home-manager.users.${username} = let
      vscode-marketplace =
        if pkgs ? vscode-marketplace
        then pkgs.vscode-marketplace
        else
          (
            if config ? nixpkgs.pkgs.vscode-marketplace
            then builtins.trace "Using config.nixpkgs.pkgs.vscode-marketplace" config.nixpkgs.pkgs.vscode-marketplace
            else builtins.trace "No vscode-marketplace found!" null
          );
    in {
      programs.vscode = {
        enable =
          if vscode-marketplace != null
          then true
          else
            (builtins.trace ''

                WARNING: VScode cannot be enabled. vscode-marketplace not found in nixpkgs,
                overlay is not installed, ensure inputs.nix-vscode-extensions.overlays.default
                overlay is installed
              ''
              false);

        mutableExtensionsDir = true;

        profiles = let
          vscode-extensions = vscode-marketplace;

          shared-extensions = [
            vscode-extensions.streetsidesoftware.code-spell-checker
            vscode-extensions.bierner.markdown-mermaid
            vscode-extensions.pomdtr.excalidraw-editor

            vscode-extensions.vscodevim.vim
            vscode-extensions.vspacecode.vspacecode
            vscode-extensions.vspacecode.whichkey
            vscode-extensions.kahole.magit

            vscode-extensions.jnoortheen.nix-ide

            vscode-extensions.ms-vscode-remote.remote-containers
            vscode-extensions.ms-vscode-remote.remote-ssh
            vscode-extensions.ms-vscode-remote.remote-ssh-edit

            # vscode-extensions.github.copilot
            # pkgs.vscode-extensions.github.copilot-chat
            vscode-extensions.github.vscode-github-actions

            vscode-extensions.bodil.file-browser
            vscode-extensions.rodrigocfd.format-comment
            # vscode-extensions.eamodio.gitlens

            vscode-extensions.catppuccin.catppuccin-vsc-icons
            vscode-extensions.lakshits11.best-themes-redefined
          ];

          d2-diagrams = [
            vscode-extensions.rohanshetty.lspd2
            vscode-extensions.kdheepak.d2-markdown-preview
          ];

          js-ts-extensions = [
            vscode-extensions.dbaeumer.vscode-eslint
            vscode-extensions.esbenp.prettier-vscode
            vscode-extensions.yoavbls.pretty-ts-errors
            # vscode-extensions.wallabyjs.quokka-vscode
            # vscode-extensions.wallabyjs.wallaby-vscode
            # vscode-extensions.wallabyjs.console-ninja
          ];

          python-extensions = [
            vscode-extensions.ms-python.python
            vscode-extensions.charliermarsh.ruff
          ];

          terraform-extensions = [
            vscode-extensions.hashicorp.terraform
          ];
        in {
          default = {
            # extensions = shared-extensions ++ js-ts-extensions;
            extensions =
              shared-extensions
              ++ js-ts-extensions
              ++ python-extensions
              ++ d2-diagrams
              # ++ terraform-extensions
              ++ builtins.concatMap (fn: (
                if (builtins.isFunction fn)
                then (fn vscode-extensions)
                else if (builtins.isList fn)
                then fn
                else []
              ))
              config.features.vscode.extensions;
          };
          # python = {
          #   userSettings = userSettings;
          #   keybindings = keybindings;

          #   extensions = shared-extensions ++ python-extensions;
          # };
          # terraform = {
          #   userSettings = userSettings;
          #   keybindings = keybindings;

          #   extensions = shared-extensions ++ terraform-extensions;
          # };
        };
      };
    };
  };
}
