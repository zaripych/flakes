#!/usr/bin/env nix-shell
#! nix-shell -i bash -p git gh nix

# if homebrew is not installed, install it
if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ ! -d ~/Projects/flakes ]; then
  mkdir -p ~/Projects/

  gh auth login || true
  gh repo clone zaripych/flakes ~/Projects/flakes
fi

nix develop ~/Projects/flakes/macos --command darwin-rebuild switch --flake ~/Projects/flakes/macos#default
