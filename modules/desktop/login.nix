{
  config,
  lib,
  pkgs,
  ...
}:

let
  tuigreet = lib.getExe pkgs.tuigreet;
  niriSession = "${config.programs.niri.package}/bin/niri-session";
in
{
  services.greetd = {
    enable = true;
    useTextGreeter = true;

    settings.default_session = {
      command = builtins.concatStringsSep " " [
        tuigreet
        "--time"
        "--remember"
        "--asterisks"
        "--cmd"
        niriSession
      ];

      user = "greeter";
    };
  };
}
