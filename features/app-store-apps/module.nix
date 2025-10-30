{ ...
}: {

  homebrew = {
    enable = true;

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
