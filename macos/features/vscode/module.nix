{ pkgs
, inputs
, username
, useFeatureAt
, config
, ...
}:
let
  replaceComments = input:
    builtins.concatStringsSep "\n"
      (builtins.filter
        (item: !builtins.isList item)
        (builtins.split "//[^\n]*"
          input)
      );
in
{
  imports = [
    (useFeatureAt ../home-manager/module.nix)
    {
      nixpkgs.overlays = [
        inputs.nix-vscode-extensions.overlays.default
      ];
    }
  ];

  config = {

    home-manager.users.${username} =
      let
        vscode-marketplace = (if pkgs ? vscode-marketplace then
          builtins.trace "Using pkgs.vscode-marketplace" pkgs.vscode-marketplace
        else
          (if config ? nixpkgs.pkgs.vscode-marketplace then
            builtins.trace "Using config.nixpkgs.pkgs.vscode-marketplace" config.nixpkgs.pkgs.vscode-marketplace
          else
            builtins.trace "No vscode-marketplace found!" null));
      in
      {
        programs.vscode = {
          enable =
            if vscode-marketplace != null then
              true
            else
              (builtins.trace ''

              WARNING: VScode cannot be enabled. vscode-marketplace not found in nixpkgs,
              overlay is not installed, ensure inputs.nix-vscode-extensions.overlays.default
              overlay is installed
            ''
                false);

          mutableExtensionsDir = true;

          profiles =
            let
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

                vscode-extensions.github.copilot
                pkgs.vscode-extensions.github.copilot-chat
                vscode-extensions.github.vscode-github-actions

                vscode-extensions.zhuangtongfa.material-theme # One Dark Pro
                vscode-extensions.pkief.material-icon-theme

                vscode-extensions.bodil.file-browser
                vscode-extensions.rodrigocfd.format-comment
                vscode-extensions.eamodio.gitlens
              ];

              js-ts-extensions = [
                vscode-extensions.esbenp.prettier-vscode
                vscode-extensions.yoavbls.pretty-ts-errors
                vscode-extensions.wallabyjs.quokka-vscode
                vscode-extensions.wallabyjs.wallaby-vscode
              ];

              python-extensions = [
                vscode-extensions.ms-python.python
                vscode-extensions.ms-python.black-formatter
                vscode-extensions.charliermarsh.ruff
              ];

              terraform-extensions = [
                vscode-extensions.hashicorp.terraform
              ];

              userSettings = builtins.fromJSON (replaceComments (pkgs.lib.readFile ./vscode-profiles/settings.json));
              keybindings = builtins.fromJSON (replaceComments (pkgs.lib.readFile ./vscode-profiles/keybindings.json));
            in
            {
              default = {
                userSettings = userSettings;
                keybindings = keybindings;

                # extensions = shared-extensions ++ js-ts-extensions;
                extensions = shared-extensions ++ js-ts-extensions ++ python-extensions ++ terraform-extensions;
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
