# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains a nix-darwin configuration flake for macOS systems. It serves as a personal dotfiles repository shared across computers, with a modular design to make components less coupled. The codebase is organized into features and profiles that can be combined to create customized system configurations.

## Key Commands

### System Setup and Management

- `~/Projects/flakes/macos/bootstrap.sh` - Initial setup script for a new machine
- `darwin-refresh` - Updates and rebuilds the system with latest changes
  - Optionally runs `git add .` on specified paths
  - Optionally updates specified flake inputs
  - Runs `darwin-rebuild switch` against the configured flake path

### Adding New Features

When adding a new feature:

1. Create a new directory under `features/` with a descriptive name
2. Add a `module.nix` file implementing the feature
3. Add the feature to `features.nix` using the pattern in that file
4. Import the feature in the appropriate profile or in your custom flake configuration

## Architecture

### Directory Structure

- `/features/` - Modular components for specific functionality
- `/profiles/` - Pre-configured combinations of features
- `/libraries/` - Helper functions and utilities
- `flake.nix` - Main configuration entry point

### Key Components

1. **Features System**:

   - Each feature is a self-contained module in the `features/` directory
   - Features typically contain a `module.nix` defining configuration
   - Some features include `overlay.nix` for package overrides

2. **Profiles System**:

   - `minimal` - Essential system configuration
   - `default` - Extends `minimal` with additional development tools and applications

3. **Host Configuration System**:

   - `mkHostConfig` function creates darwin system configurations
   - Handles setting up modules, special arguments, and patching inputs

4. **darwin-refresh Command**:
   - A tiny wrapper around `darwin-rebuild switch`
   - Defined in `./features/darwin-refresh/module.nix``
   - Simplifies the process of updating and rebuilding the system
   - Manages git staging, flake updates, and system rebuilding in one command

# Workflows

Make sure to test every change using the `darwin-rebuild` command to ensure that your modifications work as expected. To execute `darwin-rebuild` correctly on current host use `./test-build.sh` script.

```bash
./dev/test-build.sh
```

This command will do the following:

- Find the `darwin-refresh` script in your PATH and execute similar script
  but instead of doing `switch` command it will do `build` command.
- It will build the current configuration. Building involves evaluation of the
  nix expressions we used in our flake files, building the `nix-darwin` derivation, which involves creation of activation script. There is an activation script for `nix-darwin` and one for `home-manager` which is used to apply the changes made in the configuration.
- After the build is complete, the `./result` directory represent the artifacts that would be applied to the system if you were to run `darwin-refresh` with the `switch` command - which basically runs the activation scripts.

If the build command is successful, we can ask the user to try to apply the changes with:

```bash
darwin-refresh
```

## Build and Output

- If the build is successful, you can see the build results in `./result` directory, it is git ignored.
- When debugging nix-darwin activation scripts, you can see the script source code in the `./result/activate` file. The `./result/activate-user` is being deprecated, do not use it.
- When debugging home-manager activation script, determining its location might be a challenge, but can be found if you build the configuration with extra verbosity:

```bash
./dev/find-home-manager-activation-script.sh
```

## How to fix "attribute 'xxx' missing" errors

If you get something like this:

```bash
error: attribute 'dag' missing
       at /nix/store/7vkz1xqq30yds74z690l4bxnxlv07wag-source/features/vscode/module.nix:40:54:
           39|       {
           40|         home.activation.vscodeMakeSettingsEditable = inputs.home-manager.lib.dag.entryAfter [ "writeBoundary" ] ''
             |                                                      ^
           41|           echo "Running vscode-allow-editing-settings"
```

To fix the issue, wrap the expression with `builtins.trace` to see the available attributes and re-run the test script, you will get extra output.

In the above case we replaced `inputs.home-manager.lib` with `(builtins.trace inputs.home-manager.lib inputs.home-manager.lib)`. And it produced:

```
trace: { hm = «thunk»; homeManagerConfiguration = «thunk»; }
error:
      ...
```

So now we see that `lib` contains `hm` attribute we had missing in our expression: `inputs.home-manager.lib.hm.dag.entryAfter`.

--

# Commit messages

When committing code, make sure to use conventional commit messages, such as:

```
feat: add new feature
fix: fix a bug
docs: update documentation
style: apply code style changes
refactor: refactor code without changing behavior
test: add or update tests
ci: update build scripts or dependencies
chore: update dependencies
```
