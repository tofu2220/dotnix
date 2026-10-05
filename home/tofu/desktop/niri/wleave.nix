{ pkgs, ... }:

{
  programs.wleave = {
    enable = true;

    settings = {
      buttons-per-row = "3";

      buttons = [
        {
          label = "lock";
          action = "swaylock -f";
          text = "Lock";
          keybind = "l";
          icon = "${pkgs.wleave}/share/wleave/icons/lock.svg";
        }
        {
          label = "hibernate";
          action = "systemctl hibernate";
          text = "Hibernate";
          keybind = "h";
          icon = "${pkgs.wleave}/share/wleave/icons/hibernate.svg";
        }
        {
          label = "logout";
          action = "niri msg action quit --skip-confirmation";
          text = "Logout";
          keybind = "e";
          icon = "${pkgs.wleave}/share/wleave/icons/logout.svg";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
          icon = "${pkgs.wleave}/share/wleave/icons/shutdown.svg";
        }
        {
          label = "suspend";
          action = "systemctl suspend";
          text = "Suspend";
          keybind = "u";
          icon = "${pkgs.wleave}/share/wleave/icons/suspend.svg";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
          icon = "${pkgs.wleave}/share/wleave/icons/reboot.svg";
        }
      ];
    };
  };
}
