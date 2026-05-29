{
  username,
  inputs,
  ...
}: let
  claudeTmpDir = "/Users/${username}/.cache/pi/tmp";
  piAgentDir = "/Users/${username}/.pi/agent";
in {
  imports = [../home-manager/module.nix];

  environment.variables = {
    CLAUDE_TMPDIR = claudeTmpDir;
  };

  launchd.user.envVariables = {
    CLAUDE_TMPDIR = claudeTmpDir;
  };

  home-manager.users."${username}" = {
    home.sessionVariables = {
      CLAUDE_TMPDIR = claudeTmpDir;
    };

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
  };
}
