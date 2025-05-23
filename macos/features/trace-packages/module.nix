{ pkgs
, config
, username
, ...
}:
let
  special = builtins.fromJSON '' "\u001b" '';
  codes = {
    white = "1;37";
    muted = "2;37";
  };
  coloredOutput = text: codes: special + "[" + codes + "m" + text + special + "[0m";

  packageInfo = pkg:
    builtins.concatStringsSep " " [
      (coloredOutput (toString pkg.name) codes.white)
      (coloredOutput (toString pkg) codes.muted)
    ];

  traceList = prefix: list: elementPrinter: builtins.trace
    (prefix + "\n  " + builtins.concatStringsSep "\n  " (builtins.map elementPrinter list))
    false;
  systemPackages = traceList "Using nix-darwin to install (environment.systemPackages):" config.environment.systemPackages packageInfo;
  syncedApps = traceList "Using nix-darwin to install (environment.syncedApps):" (if config.environment ? syncedApps then config.environment.syncedApps else [ ]) packageInfo;
  userPackages = traceList "Using home-manager to install (environment.syncedApps):" (if config ? home-manager then config.home-manager.users.${username}.home.packages else [ ]) packageInfo;
in
{
  assertions = [
    {
      assertion = systemPackages || syncedApps || userPackages || true;
      message = "prints system-packages";
    }
  ];
}
