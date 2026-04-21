{pkgs, ...}: let
  aerospace-swipe = pkgs.callPackage ./default.nix {};
in {
  environment.systemPackages = [aerospace-swipe];

  launchd.user.agents.aerospace-swipe = {
    serviceConfig = {
      Label = "org.nixos.aerospace-swipe";
      ProgramArguments = ["${aerospace-swipe}/bin/swipe"];
      RunAtLoad = true;
      KeepAlive = true;
      LimitLoadToSessionType = "Aqua";
      ProcessType = "Interactive";
      Nice = 0;
      StandardOutPath = "/tmp/swipe.out";
      StandardErrorPath = "/tmp/swipe.err";
    };
  };
}
