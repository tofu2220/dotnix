let
  flakePath =
    let
      override = builtins.getEnv "DOTNIX_TEST_FLAKE";
    in
    if override == "" then toString ../. else override;
  flake = builtins.getFlake flakePath;
  hosts = [
    "dell"
    "e14"
    "t14"
  ];
  allHosts = predicate: builtins.all (host: predicate flake.nixosConfigurations.${host}.config) hosts;
  app = builtins.readFile ../home/config/niri/config.d/app.kdl;
  media = builtins.readFile ../home/config/niri/config.d/media.kdl;
  layout = builtins.readFile ../home/config/niri/config.d/layout.kdl;
  focus = builtins.readFile ../home/config/niri/config.d/focus.kdl;
  screenshot = builtins.readFile ../home/config/niri/config.d/screenshot.kdl;
  desktop = builtins.readFile ../home/tofu/desktop/niri/default.nix;
  noctaliaModule = builtins.readFile ../home/tofu/desktop/niri/noctalia.nix;
  niriFiles = builtins.readDir ../home/config/niri/config.d;
  niriText = builtins.concatStringsSep "\n" (
    map (name: builtins.readFile (builtins.toPath "${toString ../home/config/niri/config.d}/${name}")) (
      builtins.attrNames niriFiles
    )
  );
  activeShellText = desktop + noctaliaModule + niriText;
  has = text: fragment: builtins.match ".*${fragment}.*" text != null;
  repoFile = relative: builtins.toPath "${toString ../.}/${relative}";
  retiredFiles = [
    "home/tofu/desktop/niri/fuzzel.nix"
    "home/tofu/desktop/niri/swayidle.nix"
    "home/tofu/desktop/niri/swaylock.nix"
    "home/tofu/desktop/niri/swaync.nix"
    "home/tofu/desktop/niri/waybar.nix"
    "home/tofu/desktop/niri/wlogout.nix"
    "home/config/swaync/config.json"
    "home/config/swaync/style.css"
    "home/config/waybar/config.jsonc"
    "home/config/waybar/style.css"
    "home/config/waybar/modules/backlight.jsonc"
    "home/config/waybar/modules/battery.jsonc"
    "home/config/waybar/modules/bluetooth.jsonc"
    "home/config/waybar/modules/clock.jsonc"
    "home/config/waybar/modules/cpu.jsonc"
    "home/config/waybar/modules/memory.jsonc"
    "home/config/waybar/modules/network.jsonc"
    "home/config/waybar/modules/notification.jsonc"
    "home/config/waybar/modules/pulseaudio.jsonc"
    "home/config/waybar/modules/tray.jsonc"
    "home/config/waybar/modules/workspaces.jsonc"
  ];
  hasPackage = hmConfig: pname: builtins.any (p: (p.pname or "") == pname) hmConfig.home.packages;
  hm = c: c.home-manager.users.tofu;
  noctaliaSettings = c: (hm c).programs.noctalia.settings;
in
{
  packaging =
    assert allHosts (c: c.home-manager.users.tofu.programs.noctalia.enable or false);
    assert allHosts (c: c.home-manager.users.tofu.programs.noctalia.checkConfig or false);
    assert allHosts (c: (c.home-manager.users.tofu.programs.noctalia.package.version or "") == "5.3.0");
    true;

  session =
    assert allHosts (c: (hm c).programs.noctalia.systemd.enable);
    assert allHosts (
      c:
      let
        s = noctaliaSettings c;
      in
      s.idle.behavior.lock == {
        enabled = true;
        timeout = 600;
        action = "lock";
      }
      &&
        s.idle.behavior.screen-off == {
          enabled = true;
          timeout = 601;
          action = "screen_off";
        }
      && s.idle.pre_action_fade_seconds == 0
      && !(s.idle.behavior ? suspend)
      && s.lockscreen.enabled
      && s.lockscreen.grace_period_seconds == 0
      && s.shell.font_family == "JetBrainsMono Nerd Font"
      && s.shell.launch_apps_as_systemd_services
      && s.shell.polkit_agent
      && !s.shell.clipboard_enabled
      && !s.shell.telemetry_enabled
      && !s.shell.niri_overview_type_to_launch_enabled
      && !s.theme.templates.enable_builtin_templates
      && !s.theme.templates.enable_community_templates
      && s.theme.mode == "light"
      && s.theme.source == "builtin"
      && s.theme.builtin == "Catppuccin"
      && s.bar.main.position == "top"
      && s.bar.main.reserve_space
      && !s.bar.main.compositor_blur
      && s.bar.main.margin_ends == 0
      && s.bar.main.start == [ "workspaces" ]
      &&
        s.bar.main.center == [
          "clock"
          "notifications"
        ]
      &&
        s.bar.main.end == [
          "tray"
          "bluetooth"
          "network"
          "volume"
          "brightness"
          "battery"
          "control-center"
          "session"
        ]
      && !s.wallpaper.enabled
      && !s.backdrop.enabled
      && !s.dock.enabled
      && !s.desktop_widgets.enabled
      && !s.calendar.enabled
      && !s.weather.enabled
      && !s.nightlight.enabled
    );
    assert allHosts (
      c:
      !(hm c).programs.waybar.enable
      && !(hm c).programs.fuzzel.enable
      && !(hm c).services.swaync.enable
      && !(hm c).services.swayidle.enable
      && !(hm c).programs.swaylock.enable
      && !(hm c).programs.wlogout.enable
      && !(c.security.soteria.enable or false)
      && !(c.security.pam.services.swaylock.enable or false)
    );
    assert allHosts (
      c:
      c.networking.networkmanager.enable
      && c.hardware.bluetooth.enable
      && c.services.upower.enable
      && c.programs.auto-cpufreq.enable
      && !c.services.power-profiles-daemon.enable
      && !c.services.tuned.enable
      && c.services.upower.criticalPowerAction == "PowerOff"
    );
    assert allHosts (c: c.security.pam.services.login.enable);
    assert allHosts (c: builtins.stringLength c.security.pam.services.login.text > 0);
    true;

  bindings =
    let
      c = flake.nixosConfigurations.e14.config;
      service = (hm c).systemd.user.services.noctalia;
    in
    assert service.Unit.PartOf == [ "niri.service" ];
    assert service.Unit.After == [ "niri.service" ];
    assert service.Install.WantedBy == [ "niri.service" ];
    assert service.Service.ExecStart == [ "${(hm c).programs.noctalia.package}/bin/noctalia" ];
    assert !(has niriText "spawn-at-startup[[:space:]]+\"noctalia\"");
    assert !(has app "LAUNCHER[[:space:]]+\"fuzzel\"");
    assert has layout "match app-id=\"dev.noctalia.Noctalia\"";
    assert has layout "open-floating true";
    assert has layout "default-column-width.*fixed 1080";
    assert has layout "default-window-height.*fixed 920";
    assert has app "Mod\\+D.*noctalia.*msg.*panel-toggle.*launcher";
    assert has app "Mod\\+Shift\\+E.*noctalia.*msg.*panel-toggle.*session";
    assert has app "Mod\\+Escape repeat=false.*noctalia.*msg.*session.*lock";
    assert has app "Mod\\+Comma repeat=false.*noctalia.*msg.*settings-toggle";
    assert has app "Mod\\+S repeat=false.*noctalia.*msg.*panel-toggle.*control-center";
    assert has focus "Mod\\+L.*focus-column-right";
    assert has screenshot "Print.*screenshot;" && has screenshot "Ctrl\\+Print.*screenshot-window;";
    assert has media "XF86AudioRaiseVolume allow-when-locked=true.*volume-up";
    assert has media "XF86AudioLowerVolume allow-when-locked=true.*volume-down";
    assert has media "XF86AudioMute allow-when-locked=true.*volume-mute";
    assert has media "XF86AudioMicMute allow-when-locked=true.*mic-mute";
    assert has media "XF86MonBrightnessUp allow-when-locked=true.*brightness-up";
    assert has media "XF86MonBrightnessDown allow-when-locked=true.*brightness-down";
    assert builtins.any (p: (p.pname or "") == "libnotify") (hm c).home.packages;
    true;

  retirement =
    assert builtins.all (file: !(builtins.pathExists (repoFile file))) retiredFiles;
    assert
      !(has desktop "fuzzel\\.nix")
      && !(has desktop "swayidle\\.nix")
      && !(has desktop "swaylock\\.nix")
      && !(has desktop "swaync\\.nix")
      && !(has desktop "waybar\\.nix")
      && !(has desktop "wlogout\\.nix");
    assert
      !(has activeShellText "fuzzel")
      && !(has activeShellText "wlogout")
      && !(has activeShellText "swaylock")
      && !(has activeShellText "swayidle")
      && !(has activeShellText "waybar")
      && !(has activeShellText "swaync")
      && !(has activeShellText "swaync-client")
      && !(has activeShellText "pamixer")
      && !(has activeShellText "brightnessctl");
    assert
      has desktop "\\./swayimg\\.nix"
      && has desktop "nwg-displays"
      && has desktop "wl-mirror"
      && has desktop "xwayland-satellite"
      && has desktop "\\./alacritty\\.nix"
      && has desktop "\\./fcitx5\\.nix"
      && has desktop "\\./firefox\\.nix"
      && has desktop "\\./mpv\\.nix"
      && has desktop "\\./nautilus\\.nix"
      && has layout "nwg-displays";
    assert allHosts (
      c:
      let
        h = hm c;
      in
      h.programs.swayimg.enable
      && hasPackage h "nwg-displays"
      && hasPackage h "wl-mirror"
      && hasPackage h "xwayland-satellite"
      && hasPackage h "libnotify"
      && hasPackage h "wl-clipboard"
    );
    true;
}
