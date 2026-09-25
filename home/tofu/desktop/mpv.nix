{ ... }:

{
  programs.mpv = {
    enable = true;

    config = {
      mute = "yes";
      keepaspect-window = "no";
    };
  };
}
