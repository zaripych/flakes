{
  username,
  inputs,
  ...
}: let
  claudeTmpDir = "/Users/${username}/.cache/pi/tmp";
  piAgentDir = "/Users/${username}/.pi/agent";
  suppressUndiciExperimentalProxyAgentWarning = ''
    case " ''${NODE_OPTIONS-} " in
      *" --disable-warning=UNDICI-EHPA "*) ;;
      *) export NODE_OPTIONS="''${NODE_OPTIONS:+$NODE_OPTIONS }--disable-warning=UNDICI-EHPA" ;;
    esac
  '';
in {
  imports = [../home-manager/module.nix];

  environment.variables = {
    CLAUDE_TMPDIR = claudeTmpDir;
  };

  # Append to NODE_OPTIONS instead of setting it as a plain env var so existing
  # options are preserved and the warning suppression is not duplicated.
  environment.extraInit = suppressUndiciExperimentalProxyAgentWarning;

  launchd.user.envVariables = {
    CLAUDE_TMPDIR = claudeTmpDir;
  };

  home-manager.users."${username}" = {
    home.sessionVariables = {
      CLAUDE_TMPDIR = claudeTmpDir;
    };
    home.sessionVariablesExtra = suppressUndiciExperimentalProxyAgentWarning;

    xdg.cacheFile."pi/tmp/.keep".text = "";
  };

  outOfStoreLinks.links = {
    "${piAgentDir}/sandbox.json" = {
      flake = inputs.self;
      linkFrom = "features/pi-configs/configs/sandbox.json";
    };
    "${piAgentDir}/models.json" = {
      flake = inputs.self;
      linkFrom = "features/pi-configs/configs/models.json";
    };
    "${piAgentDir}/AGENTS.md" = {
      flake = inputs.self;
      linkFrom = "features/pi-configs/configs/AGENTS.md";
    };
    "${piAgentDir}/settings.json" = {
      flake = inputs.self;
      linkFrom = "features/pi-configs/configs/settings.json";
    };
    "${piAgentDir}/web-fetch.json" = {
      flake = inputs.self;
      linkFrom = "features/pi-configs/configs/web-fetch.json";
    };
    "${piAgentDir}/review.yaml" = {
      flake = inputs.self;
      linkFrom = "features/pi-configs/configs/review.yaml";
    };
    "${piAgentDir}/review-prompt.md" = {
      flake = inputs.self;
      linkFrom = "features/pi-configs/configs/review-prompt.md";
    };
  };
}
