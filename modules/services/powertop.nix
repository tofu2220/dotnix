{ config, lib, ... }:

{
  # This is workaround. More information: fenrus75/powertop/issues/38
  services.udev.extraRules = ''
    # This USB mouse does not wake reliably from autosuspend.
    ACTION=="add|bind", SUBSYSTEM=="usb", ATTR{idVendor}=="0461", ATTR{idProduct}=="4d81", TEST=="power/control", ATTR{power/control}="on"
  '';

  powerManagement.powertop = {
    enable = true;
    # Reapply the mouse exception after auto-tune overrides USB power settings.
    postStart = ''
      ${lib.getExe' config.systemd.package "udevadm"} trigger --settle --action=bind --subsystem-match=usb --attr-match=idVendor=0461 --attr-match=idProduct=4d81
    '';
  };
}
