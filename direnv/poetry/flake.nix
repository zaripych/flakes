{
  description = "poetry dev env flake";

  inputs = {
    # Common flake utils
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            # Add overlays here, see https://nixos.org/manual/nixpkgs/stable/#chap-overlays
          ];
        };

        shell = pkgs.mkShell rec {
          # Executable packages
          packages = with pkgs; [
            # We want to run these commands in the shell
            python311
            (poetry.override {
              python3 = python311;
            })
            glow
            zsh
          ];

          # Build dependencies for python packages
          inputsFrom = with pkgs; [

          ] ++ lib.optionals stdenv.isDarwin [ ];

          nativeBuildInputs = with pkgs; [
            pkg-config
          ];

          # Set poetry to use the current directory for virtualenvs
          POETRY_VIRTUALENVS_PATH = "./.venv";

          DOCS = ''
            # Welcome

            You can now run the following command to install the project dependencies:
            ```sh
            poetry install --no-root
            ```

            After that you can activate your development environment via
            ```sh
            poetry activate
            ```
          '';

          ALREADY_INSIDE_HINT = ''
            # **WARNING**

            You are already inside the dev environment if you want to rebuild the environment, you
            should `exit` the current shell and then run `nix develop ./nix` again.
          '';

          shellHook = ''
            if [ "$INSIDE_DEV_ENVIRONMENT" == "yes" ]; then
              echo "$ALREADY_INSIDE_HINT" | glow
              exit 1;
            fi

            export INSIDE_DEV_ENVIRONMENT='yes'

            echo "$DOCS" | glow

            # Add prompt suffix so we now that we have the shell running
            # already
            mkdir -p $TMP/deploy-tools/
            cat <<'EOF' >> $TMP/deploy-tools/.zshrc
            PROMPT+='(nix) '
            plugins+=(poetry)
            EOF

            ZDOTDIR=$TMP/deploy-tools/ zsh
            exit $?
          '';
        };
      in
      {
        devShells = {
          default = shell;
        };
        legacyPackages = pkgs;
      });
}

