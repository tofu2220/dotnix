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

      terminal = {
        font_family = "Hack Nerd Font";
      };

      telemetry = {
        diagnostics = false;
        metrics = false;
        anthropic_retention = false;
      };
    };
  };
}
