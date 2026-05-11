{
  username,
  inputs,
  ...
}: {
  outOfStoreLinks.links = let
    piAgentDir = "/Users/${username}/.pi/agent";
  in {
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
