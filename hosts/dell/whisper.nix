{ pkgs, ... }:

{
  home.packages = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    libsndfile
    portaudio
    libcxx
    python313Packages.pygobject3
    gtk3
    webkitgtk_4_1
    gobject-introspection
  ];
}
