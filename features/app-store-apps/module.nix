{ ...
}: {

  homebrew = {
    enable = true;

    # Apps that self-update (or that we update manually via `brew upgrade`).
    # Installed via casks so they live writable in /Applications and their
    # self-updaters work, unlike nix-store copies.
    casks = [
      "1password"
      "docker-desktop"
    ];

    masApps = {
      "Amphetamine" = 937984704;
      "Moom Classic" = 419330170;
      "Slack" = 803453959;
    };
  };

  environment.systemPath = [
    "/opt/homebrew/bin"
  ];
}
