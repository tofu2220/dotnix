{ ... }:

{
  dconf.settings."org/gnome/nautilus/preferences" = {
    default-folder-viewer = "list-view";
    default-sort-order = "type";
    default-sort-in-reverse-order = false;
  };

  home.file."Templates/Empty File".text = "";

  xdg.configFile."gtk-3.0/bookmarks".text = ''
    file:///home/tofu/Desktop Desktop
    file:///home/tofu/Documents Documents
    file:///home/tofu/Downloads Downloads
    file:///home/tofu/Music Music
    file:///home/tofu/Pictures Pictures
    file:///home/tofu/Projects Projects
    file:///home/tofu/Public Public
    file:///home/tofu/Templates Templates
    file:///home/tofu/Videos Videos
  '';
}
