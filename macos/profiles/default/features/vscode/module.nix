{ pkgs
, config
, lib
, inputs
, username
, useFeatureAt
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
  vscode-extensions = inputs.nix-vscode-extensions.extensions.aarch64-darwin.vscode-marketplace;

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
  imports = [
    (useFeatureAt ../../../../features/home-manager/module.nix)
  ];

  home-manager.users.${username} = {
    programs.vscode = {
      enable = true;

      mutableExtensionsDir = true;

      userSettings = userSettings;
      keybindings = keybindings;

      extensions = shared-extensions ++ js-ts-extensions ++ python-extensions ++ terraform-extensions;

      # profiles = {
      #   default = {
      #     userSettings = userSettings;
      #     keybindings = keybindings;

      #     extensions = shared-extensions ++ js-ts-extensions;
      #   };
      #   python = {
      #     userSettings = userSettings;
      #     keybindings = keybindings;

      #     extensions = shared-extensions ++ python-extensions;
      #   };
      #   terraform = {
      #     userSettings = userSettings;
      #     keybindings = keybindings;

      #     extensions = shared-extensions ++ terraform-extensions;
      #   };
      # };
    };
  };
}
