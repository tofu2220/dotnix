{ pkgs, ... }:

{
  services.swayidle = {
    enable = true;

    timeouts = [
      {
        timeout = 600;
        command = "${pkgs.swaylock}/bin/swaylock -f -c 1e1e2e";
      }
      {
        timeout = 601;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
      }
    ];

    events."before-sleep" = "${pkgs.swaylock}/bin/swaylock -f -c 1e1e2e";
  };
}
