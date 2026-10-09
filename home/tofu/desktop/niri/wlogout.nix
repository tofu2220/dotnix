{ ... }:

{
  programs.wlogout = {
    enable = true;

    layout = [
      {
        label = "lock";
        action = "swaylock -f";
        text = "  Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "niri msg action quit --skip-confirmation";
        text = "󰍃  Logout";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "  Suspend";
        keybind = "u";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "󰤄  Hibernate";
        keybind = "h";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "  Shutdown";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "  Reboot";
        keybind = "r";
      }
    ];

    style = ''
      * {
          background-image: none;
          font-family: "JetBrainsMono Nerd Font";
      }

      window {
          background-color: rgba(0, 0, 0, 0.45);
      }

      button {
          font-size: 28px;
          color: #eeeeee;
          background-color: rgba(30, 30, 30, 0.90);
          border: none;
          border-radius: 14px;
          margin: 10px;
          padding: 20px 30px;
      }

      button:hover,
      button:focus {
          background-color: rgba(255, 255, 255, 0.12);
      }
    '';
  };
}
