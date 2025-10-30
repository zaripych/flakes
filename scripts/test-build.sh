#!/usr/bin/env bash

# Replace "switch" with build in the "darwin-refresh" script
source <(cat $(which darwin-refresh) | sed s/switch/build/ | sed s/sudo\ //)