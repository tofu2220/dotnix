{ pkgs, ... }:

# This is just workaround, will find real fix later

let
  ucmFboot = pkgs.writeShellScript "t14-ucm-fboot" ''
    set -eu

    # Chờ cả HDA card và ACP digital-mic card xuất hiện.
    for _ in $(seq 1 20); do
      if grep -q 'Generic_1' /proc/asound/cards \
        && grep -q 'acp6x' /proc/asound/cards; then
        exec ${pkgs.alsa-utils}/bin/alsaucm \
          -c hw:Generic_1 set _fboot ""
      fi

      sleep 0.25
    done

    echo "Generic_1/acp6x were not both available" >&2
    exit 1
  '';
in
{
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="sound", KERNEL=="controlC*", \
      TAG+="systemd", \
      ENV{SYSTEMD_WANTS}+="t14-ucm-fboot.service"
  '';

  systemd.services.t14-ucm-fboot = {
    description = "Initialize ALSA UCM fixed-boot state for ThinkPad T14";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ucmFboot;
    };
  };
}
