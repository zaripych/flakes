{
  lib,
  pkgs,
  username,
  ...
}: let
  home = "/Users/${username}";
  ankiDir = "${home}/.anki";
  launcher = pkgs.writeShellScript "anki-sync-server" ''
    set -eu

    umask 077
    mkdir -p ${lib.escapeShellArg "${ankiDir}/data"}

    env_file=${lib.escapeShellArg "${ankiDir}/.env"}
    if [ ! -s "$env_file" ]; then
      printf 'ANKI_SYNC_PASSWORD=%s\n' "$(${lib.getExe pkgs.openssl} rand -base64 32)" > "$env_file"
    fi
    chmod 600 "$env_file"

    set -a
    . "$env_file"
    set +a
    : "''${ANKI_SYNC_PASSWORD:?ANKI_SYNC_PASSWORD is missing from $env_file}"

    export SYNC_USER1=${lib.escapeShellArg "${username}:"}"$ANKI_SYNC_PASSWORD"
    export SYNC_HOST=0.0.0.0
    export SYNC_PORT=8183
    export SYNC_BASE=${lib.escapeShellArg "${ankiDir}/data"}
    exec ${lib.getExe pkgs.anki-sync-server}
  '';
in {
  launchd.user.agents.anki-sync-server.serviceConfig = {
    Label = "org.nixos.anki-sync-server";
    ProgramArguments = ["${launcher}"];
    RunAtLoad = true;
    KeepAlive = true;
  };
}
