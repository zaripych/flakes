{ inputs
, system
, username
}:
let
  nixpkgs = import inputs.nixpkgs {
    inherit system;

    config = {
      allowUnfree = true;
    };

    overlays = [
      (final: prev: {
        nodejs = prev.nodejs_20;
      })
    ];
  };

  all-packages = import ../../packages/all-packages.nix { inherit nixpkgs; };

  global-npm-packages = nixpkgs.callPackage ../../global-npm-packages
    {
      # Add global npm packages to ./npm-packages/package.json
      # and run `pnpm install` to update the lock file, after which
      # you can run `darwin-refresh` to make them globally available
      pnpm-packages-src = ./npm-packages;
      # Hash of the fetched dependencies, omit it to calculate the
      # hash and then update the value
      pnpm-packages-deps-hash = "sha256-b4DyUQFNJiIUUUQRzMo3KUdFPoAt39n1aEG457GlCJM=";
    };

  system-packages = with nixpkgs; [
    nil
    nixpkgs-fmt
    nix-search-cli
    git
    git-lfs
    jq
    fzf
    nodejs
    nodePackages.pnpm
    global-npm-packages
    _1password-cli

    iterm2
    all-packages.docker-desktop
    all-packages.arc-browser
    haskellPackages.patat
  ];

  synced-apps = [
    all-packages._1password-gui
  ];

  mas-apps = {
    "Amphetamine" = 937984704;
    "Moom Classic" = 419330170;
    "Slack" = 803453959;
  };

  modules = [
    inputs.mac-app-utils.darwinModules.default
    ../../modules/synced-apps.nix
    ../../modules/oh-my-zsh.nix
  ];

  oh-my-zsh-plugins = [
    "git"
  ];

  fonts = with nixpkgs; [
    powerline-fonts
  ];

  home-manager = {
    home = ({ config, pkgs, ... }: {
      home.username = username;
      home.stateVersion = "25.05";

      programs.home-manager.enable = true;

      programs.vscode =
        let
          replaceComments = input:
            builtins.concatStringsSep "\n"
              (builtins.filter
                (item: !builtins.isList item)
                (builtins.split "//[^\n]*"
                  input)
              );
          vscode-extensions = inputs.nix-vscode-extensions.extensions.aarch64-darwin.vscode-marketplace;
        in
        {
          enable = true;

          userSettings = builtins.fromJSON (replaceComments (pkgs.lib.readFile ./vscode/settings.json));
          keybindings = builtins.fromJSON (replaceComments (pkgs.lib.readFile ./vscode/keybindings.json));

          mutableExtensionsDir = true;

          extensions = [
            vscode-extensions.streetsidesoftware.code-spell-checker
            vscode-extensions.bierner.markdown-mermaid
            vscode-extensions.pomdtr.excalidraw-editor

            vscode-extensions.esbenp.prettier-vscode

            vscode-extensions.vscodevim.vim
            vscode-extensions.vspacecode.vspacecode
            vscode-extensions.vspacecode.whichkey
            vscode-extensions.kahole.magit

            vscode-extensions.jnoortheen.nix-ide

            vscode-extensions.ms-vscode-remote.remote-containers
            vscode-extensions.ms-vscode-remote.remote-ssh
            vscode-extensions.ms-vscode-remote.remote-ssh-edit

            vscode-extensions.yoavbls.pretty-ts-errors

            vscode-extensions.wallabyjs.quokka-vscode
            vscode-extensions.wallabyjs.wallaby-vscode

            vscode-extensions.github.copilot
            vscode-extensions.github.copilot-chat
            vscode-extensions.github.vscode-github-actions

            vscode-extensions.zhuangtongfa.material-theme # One Dark Pro
            vscode-extensions.pkief.material-icon-theme

            vscode-extensions.bodil.file-browser
            vscode-extensions.rodrigocfd.format-comment
            vscode-extensions.eamodio.gitlens

            # pkgs.vscode-extensions.monokai.theme-monokai-pro-vscode
            # bodil.file-browser
            # dbaeumer.vscode-eslint
            # donjayamanne.python-environment-manager
            # dorzey.vscode-sqlfluff
            # dotjoshjohnson.xml
            # eamodio.gitlens
            # editorconfig.editorconfig
            # equinusocio.vsc-community-material-theme
            # equinusocio.vsc-material-theme
            # equinusocio.vsc-material-theme-icons
            # foxundermoon.shell-format
            # github.remotehub
            # github.vscode-github-actions
            # github.vscode-pull-request-github
            # golang.go
            # hashicorp.terraform
            # hbenl.vscode-test-explorer
            # humao.rest-client
            # jacobdufault.fuzzy-search
            # jeff-hykin.better-dockerfile-syntax
            # kahole.magit
            # kawamataryo.copy-python-dotted-path
            # kevinrose.vsc-python-indent
            # littlefoxteam.vscode-python-test-adapter
            # mechatroner.rainbow-csv
            # ms-azuretools.vscode-docker
            # ms-python.black-formatter
            # ms-python.debugpy
            # ms-python.isort
            # ms-python.python
            # ms-python.vscode-pylance
            # ms-toolsai.jupyter
            # ms-toolsai.jupyter-keymap
            # ms-toolsai.jupyter-renderers
            # ms-toolsai.vscode-jupyter-cell-tags
            # ms-toolsai.vscode-jupyter-slideshow
            # 
            # ms-vscode-remote.vscode-remote-extensionpack
            # ms-vscode.azure-repos
            # ms-vscode.live-server
            # ms-vscode.remote-explorer
            # ms-vscode.remote-repositories
            # ms-vscode.remote-server
            # ms-vscode.test-adapter-converter
            # ms-vscode.vscode-js-profile-flame
            # ms-vsliveshare.vsliveshare
            # njpwerner.autodocstring
            # pkgs.vscode-extensions."4ops".terraform
            # rodrigocfd.format-comment
            # ryanluker.vscode-coverage-gutters
            # ryuta46.multi-command
            # scott-blair.copy-breadcrumbs
            # shakram02.bash-beautify
            # tamasfe.even-better-toml
            # yoavbls.pretty-ts-errors
            # zhuangtongfa.material-theme
            # zxh404.vscode-proto3
            #
            # ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            # {
            #  name = "remote-ssh-edit";
            #  publisher = "ms-vscode-remote";
            #  version = "0.47.2";
            #  sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
            # }]
          ];
        };
    });
  };

in
{
  inherit nixpkgs;

  inherit system-packages;
  inherit synced-apps;
  inherit mas-apps;

  inherit oh-my-zsh-plugins;
  inherit fonts;

  inherit modules;

  inherit home-manager;
}
