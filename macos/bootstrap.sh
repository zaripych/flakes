#!/usr/bin/env nix-shell
#! nix-shell -i bash -p git gh nix

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

nix --extra-experimental-features "nix-command flakes" develop ~/Projects/flakes/macos --command darwin-rebuild switch --flake ~/Projects/flakes/macos#default
