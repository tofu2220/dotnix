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
      name = "Colloid-Light";
    };

    iconTheme = {
      package = pkgs.colloid-icon-theme;
      name = "Colloid-Light";
    };
  };

  fonts.fontconfig.enable = true;
  home.packages = [ pkgs.nerd-fonts.hack ];
}
