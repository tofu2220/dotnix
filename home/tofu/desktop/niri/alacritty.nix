{ ... }:

{
  programs.alacritty = {
    enable = true;
    theme = "catppuccin_mocha";

    settings = {
      font = {
        normal.family = "JetBrainsMono Nerd Font";
        size = 11.0;
      };
      colors = {
        vi_mode_cursor = {
          cursor = "#ff6b00";
          text = "#000000";
        };
        selection = {
          background = "#a6e3a1";
          text = "#1e1e2e";
        };
      };
    };
  };
}
