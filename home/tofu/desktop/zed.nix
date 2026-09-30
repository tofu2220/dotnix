{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    package = pkgs.unstable.zed-editor;

    mutableUserSettings = true;

    userSettings = {
      theme = "One Light";
      base_keymap = "VSCode";
      show_edit_predictions = false;

      languages = {
        Nix = {
          language_servers = [
            "nixd"
            "!nil"
          ];
        };
      };

      agent_ui_font_family = "DejaVu Sans";

      terminal = {
        font_family = "JetBrainsMono Nerd Font";
      };

      telemetry = {
        diagnostics = false;
        metrics = false;
        anthropic_retention = false;
      };
    };
  };
}
