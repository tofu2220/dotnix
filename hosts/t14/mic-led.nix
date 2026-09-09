{ pkgs, ... }:

# Temporary workaround for an ALSA/UCM initialization-order issue on the
# ThinkPad T14.
#
# The HDA card may become available before the ACP digital-mic card is ready.
# Running the UCM FixedBootSequence only after both cards are visible restores
# the expected audio state.
#
# Keep this local until the underlying NixOS/ALSA/kernel issue no longer
# requires the workaround. The polling window is intentionally short and only
# serves as a guard against device-probe timing differences during boot.
let
  ucmFboot = pkgs.writeShellScript "t14-ucm-fboot" ''
    set -eu

    # Wait for both the HDA card and the ACP digital-mic card to appear.
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
