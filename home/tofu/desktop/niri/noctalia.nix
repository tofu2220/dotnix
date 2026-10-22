{
  lib,
  noctalia,
  pkgs,
  ...
}:
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
        mode = "dark";
        shell_mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
        pure_black_dark = false;
        templates = {
          enable_builtin_templates = false;
          enable_community_templates = false;
        };
      };

      control_center = {
        # Keep the native Bluetooth tab available in Control Center.
        hidden_tabs = [ ];
      };

      bar.default = {
        position = "top";
        enabled = true;
        auto_hide = false;
        reserve_space = true;
        layer = "top";

        thickness = 26;
        margin_edge = 0;
        margin_ends = 0;
        margin_opposite_edge = 0;
        padding = 6;
        widget_spacing = 8;

        background_opacity = 0.97;
        compositor_blur = false;
        border_width = 0.0;
        shadow = false;
        concave_edge_corners = false;
        radius = 0;
        radius_top_left = 0;
        radius_top_right = 0;
        radius_bottom_left = 0;
        radius_bottom_right = 0;

        scale = 0.94;
        font_scale = 1.0;
        font_weight = 600;
        font_family = "Inter";
        capsule = false;
        hover_highlight = false;

        start = [
          "cpu"
          "temperature"
          "ram"
          "media"
        ];

        center = [ "workspaces" ];

        end = [
          "control-center"
          "tray"
          "network"
          "bluetooth"
          "volume"
          "battery"
          "brightness"
          "notifications"
          "clock"
          "session"
        ];
      };

      widget = {
        cpu = {
          type = "sysmon";
          stat = "cpu_usage";
          visualization = "none";
          show_glyph = true;
          show_value = true;
        };

        temperature = {
          type = "sysmon";
          stat = "cpu_temp";
          visualization = "none";
          show_glyph = true;
          show_value = true;
        };

        ram = {
          type = "sysmon";
          stat = "ram_used";
          visualization = "none";
          show_glyph = true;
          show_value = true;
        };

        media = {
          type = "media";
          hide_artist = true;
          hide_album_art = false;
          hide_when_no_media = true;
          art_size = 16;
          min_length = 70;
          max_length = 165;
          title_scroll = "none";
        };

        workspaces = {
          type = "workspaces";
          style = "regular";
          show_labels = false;
          show_icons = false;
          hide_when_empty = false;

          change_color_on_hover = false;

          capsule_radius = 20.0;
          pill_scale = 0.55;
          active_pill_size = 2.8;
          inactive_pill_size = 1.0;
        };

        "control-center" = {
          type = "control-center";
          capsule = true;
          capsule_radius = 20.0;
          capsule_padding = 5.0;
        };

        network = {
          type = "network";
          show_label = false;
        };

        bluetooth = {
          type = "bluetooth";
          show_label = false;
        };

        tray = {
          type = "tray";
          drawer = true;
          match_adjacent_spacing = true;
        };

        battery = {
          type = "battery";
          display_mode = "glyph";
          show_label = true;
        };

        volume = {
          type = "volume";
          show_label = false;
        };

        brightness = {
          type = "brightness";
          show_label = false;
        };

        clock = {
          type = "clock";
          format = "{:%H:%M}";
        };
      };

      osd = {
        position = "top_right";
        orientation = "horizontal";
        hide_delay_ms = 1500;
        scale = 0.90;
        background_opacity = 0.97;
        border = false;
        offset_x = 18;
        offset_y = 40;
      };

      wallpaper.enabled = true;
      backdrop.enabled = false;
      dock.enabled = false;
      desktop_widgets.enabled = false;
      calendar.enabled = false;
      weather.enabled = false;
      nightlight.enabled = false;

      lockscreen = {
        enabled = true;
        grace_period_seconds = 0;
      };

      idle = {
        pre_action_fade_seconds = 0;
        behavior = {
          lock = {
            enabled = true;
            timeout = 600;
            action = "lock";
          };

          screen-off = {
            enabled = true;
            timeout = 601;
            action = "screen_off";
          };
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

  home.packages = [
    pkgs.libnotify
    pkgs.inter
  ];
}
