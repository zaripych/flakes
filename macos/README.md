First time setup:

```sh
nix-shell -p gh git
gh auth login
gh repo clone zaripych/flakes ~/Projects/flakes
~/Projects/flakes/macos/bootstrap.sh
```

After update in one of the profiles in `./profiles/*/default.nix`

```sh
darwin-refresh
```
