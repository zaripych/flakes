#!/usr/bin/env nix-shell
#! nix-shell -i bash -p git gh nix

ACTION="${1:-build}"

case "$ACTION" in
  build|switch) ;;
  *)
    echo "Usage: $0 [build|switch]"
    echo "  build  (default) build the configuration without applying it"
    echo "  switch           build and activate the configuration"
    exit 1
    ;;
esac

# if homebrew is not installed, install it
if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc
fi

if [ ! -d ~/Projects/flakes ]; then
  mkdir -p ~/Projects/

  gh auth login || true
  gh repo clone zaripych/flakes ~/Projects/flakes
fi

if [ ! -d ~/Projects/local-flakes ]; then
  mkdir -p ~/Projects/local-flakes

  sed \
    -e "s/YOUR_HOSTNAME/$HOSTNAME/g" \
    -e "s/YOUR_USERNAME/$USER/g" \
    ~/Projects/flakes/macos/templates/flake.nix \
    > ~/Projects/local-flakes/flake.nix
fi

nix --extra-experimental-features "nix-command flakes" develop ~/Projects/flakes/macos --command darwin-rebuild "$ACTION" --flake ~/Projects/local-flakes#"$HOSTNAME"
