{ pkgs
, config
, lib
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
  systemPackages = traceList "Using (environment.systemPackages):" config.environment.systemPackages packageInfo;
  syncedApps = traceList "Using (environment.syncedApps):" config.environment.syncedApps packageInfo;
in
{
  assertions = [
    {
      assertion = systemPackages || syncedApps || true;
      message = "prints system-packages";
    }
  ];
}
