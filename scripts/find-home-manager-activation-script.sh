#!/usr/bin/env nix-shell
#! nix-shell -i bash -p ripgrep

# First just try to build the configuration normally, so we can look for the activation
# script in the nix store using the `nix-store -q` command. This is going to be the fastest way
# to find the activation script, if it exists, but if the build fails, we cannot use this method
# because the build will not produce a valid `result` symlink.
OUTPUT=$(COLOR=1 ./scripts/test-build.sh 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
  HOME_MANAGER_GENERATION=$(nix-store -q $(readlink ./result) --tree | rg '/nix/store/.+-home-manager-generation' -m1 -o)
  if [ -n "$HOME_MANAGER_GENERATION" ]; then
    ACTIVATION_SCRIPT="$HOME_MANAGER_GENERATION/activate"
  fi
else
  # If the first build failed, we need to look for the activation script in the output
  # of the `./scripts/test-build.sh -vvv` command, which is going to be more verbose and expensive
  # - it still might not work as we might not get to the stage of the home-manager being build.
  OUTPUT=$(COLOR=1 ./scripts/test-build.sh -vvv 2>&1)
  EXIT_CODE=$?

  HOME_MANAGER_GENERATION=$(nix-store -q $(readlink ./result) --tree | rg '/nix/store/.+-home-manager-generation' -m1 -o)

  FIRST_ACTIVATION_SCRIPT=$(echo "$OUTPUT" | rg "referenced input: '(/nix/store/.+-activation-$USER)" -o -m1 -r '$1')
  if [ -n "$FIRST_ACTIVATION_SCRIPT" ]; then
    ACTIVATION_SCRIPT=$(cat "$FIRST_ACTIVATION_SCRIPT" | rg "/nix/store/.+-home-manager-generation/activate" -o)
  fi
fi

if [ -n "$ACTIVATION_SCRIPT" ]; then
  echo "$ACTIVATION_SCRIPT"
  exit 0
fi

if [ $EXIT_CODE -eq 0 ]; then
  echo "The ./scripts/test-build.sh command exited with code 0, the activation script was not found in the output. This could be indication that home-manager is disabled."
  mkdir -p $TMPDIR/find-home-manager-activation-script
  echo "$OUTPUT" > $TMPDIR/find-home-manager-activation-script/output.txt
  echo "The output of the ./scripts/test-build.sh command has been saved to $TMPDIR/find-home-manager-activation-script/output.txt"
  echo ""
else
  echo "The ./scripts/test-build.sh command exited with code $EXIT_CODE."
  echo ""
  echo "Error information:"
  echo "$OUTPUT" | grep -A 1000 "error:"
fi

exit $EXIT_CODE
