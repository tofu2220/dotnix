{ pkgs, ... }:

{
  home.pointerCursor = {
    package = pkgs.phinger-cursors;
    name = "phinger-cursors-light";
    size = 24;

    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.colloid-gtk-theme;
      name = "Colloid";
    };

    iconTheme = {
      package = pkgs.colloid-icon-theme;
      name = "Colloid";
    };
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    font-awesome_6
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];
}
