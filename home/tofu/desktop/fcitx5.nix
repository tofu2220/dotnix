{ pkgs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5 = {
      addons = [ pkgs.qt6Packages.fcitx5-unikey ];
      waylandFrontend = true;

      settings = {
        globalOptions = {
          Hotkey.AltTriggerKeys = "";

          "Hotkey/TriggerKeys"."0" = "Alt+Shift+Shift_L";
        };

        inputMethod = {
          "GroupOrder"."0" = "Default";

          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "keyboard-us";
          };

          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "unikey";
        };
      };
    };
  };
}
