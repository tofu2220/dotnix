{ lib, noctalia, pkgs, ... }:
{
  imports = [ noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
    checkConfig = true;
    systemd.enable = true;
    settings = {
      shell = {
        font_family = "JetBrainsMono Nerd Font";
        launch_apps_as_systemd_services = true;
        polkit_agent = true;
        clipboard_enabled = false;
        telemetry_enabled = false;
        niri_overview_type_to_launch_enabled = false;
      };
      theme = {
        mode = "light";
        source = "builtin";
        builtin = "Catppuccin";
        templates = {
          enable_builtin_templates = false;
          enable_community_templates = false;
        };
      };
      bar.main = {
        position = "top";
        reserve_space = true;
        compositor_blur = false;
        margin_ends = 0;
        start = [ "workspaces" ];
        center = [ "clock" "notifications" ];
        end = [ "tray" "bluetooth" "network" "volume" "brightness" "battery" "control-center" "session" ];
      };
      wallpaper.enabled = false;
      backdrop.enabled = false;
      dock.enabled = false;
      desktop_widgets.enabled = false;
      calendar.enabled = false;
      weather.enabled = false;
      nightlight.enabled = false;
      lockscreen = { enabled = true; grace_period_seconds = 0; };
      idle = {
        pre_action_fade_seconds = 0;
        behavior = {
          lock = { enabled = true; timeout = 600; action = "lock"; };
          screen-off = { enabled = true; timeout = 601; action = "screen_off"; };
        };
      };
    };
  };

  systemd.user.services.noctalia = {
    Unit = {
      PartOf = lib.mkForce [ "niri.service" ];
      After = lib.mkForce [ "niri.service" ];
    };
    Install.WantedBy = lib.mkForce [ "niri.service" ];
  };
  home.packages = [ pkgs.libnotify ];
}
