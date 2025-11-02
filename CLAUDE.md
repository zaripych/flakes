# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains Nix configuration flakes for both macOS (via nix-darwin) and Linux (via NixOS) systems. It serves as a personal dotfiles repository shared across computers, with a modular design to make components less coupled. The codebase is organized into features that can be combined to create customized system configurations for either platform.

## Key Commands

### System Setup and Management

- `bootstrap.sh` - Initial setup script for a new macOS machine (located in repository root)
- `system-refresh` - Updates and rebuilds the system with latest changes (works on both macOS and Linux)
  - Optionally runs `git add .` on specified paths
  - Optionally updates specified flake inputs
  - Runs `darwin-rebuild` (macOS) or `nixos-rebuild` (Linux) with the configured flake path

### Adding New Features

When adding a new feature:

1. Create a new directory under `features/` (for cross-platform) or `linux/features/` (for Linux-only) with a descriptive name
2. Add a `module.nix` file implementing the feature
3. Import the feature in the appropriate platform module (`macos/module.nix` or `linux/module.nix`)

## Architecture

### Directory Structure

- `/features/` - Shared modular components for specific functionality (cross-platform)
- `/macos/` - macOS-specific configuration and module imports
- `/linux/` - Linux-specific configuration and module imports
- `/linux/features/` - Linux-only features (e.g., Hyprland, key-remapping, Steam)
- `/libs/` - Helper functions and utilities
- `flake.nix` - Main configuration entry point

### Key Components

1. **Features System**:

   - Each feature is a self-contained module in the `features/` directory
   - Features typically contain a `module.nix` defining configuration
   - Some features include `overlay.nix` for package overrides
   - Platform-specific features are in `/linux/features/` for Linux-only components

2. **Platform Modules**:

   - `macos/module.nix` - Imports features and configurations for macOS systems
   - `linux/module.nix` - Imports features and configurations for Linux/NixOS systems
   - Both modules are exposed as `darwinModules.default` and `nixosModules.default` respectively

3. **system-refresh Command**:
   - A cross-platform wrapper around `darwin-rebuild` (macOS) or `nixos-rebuild` (Linux)
   - Defined in `./features/system-refresh/module.nix`
   - Simplifies the process of updating and rebuilding the system
   - Manages git staging, flake updates, and system rebuilding in one command
   - Automatically detects the platform and uses the appropriate rebuild command

# Workflows

Make sure to test every change by building the configuration first to ensure that your modifications work as expected. To test the build on the current host use the test script:

```bash
./scripts/test-build.sh
```

This command runs `system-refresh build`, which will:

- Build the current configuration without applying it, involving:
  - Evaluation of the nix expressions in the flake files
  - Building the system derivation (nix-darwin on macOS, NixOS on Linux)
  - Creating activation scripts for both the system and home-manager
- After the build completes, the `./result` directory contains the artifacts that would be applied with `system-refresh switch`

If the build command is successful, apply the changes with:

```bash
system-refresh switch
```

## Build and Output

- If the build is successful, you can see the build results in `./result` directory (git ignored)
- When debugging activation scripts, you can view the system activation script in `./result/activate`
- For home-manager activation scripts, determining the location might require inspecting the build output

**Note:** The `./scripts/test-build.sh` script has not been tested on Linux yet and may need adjustments for NixOS.

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
