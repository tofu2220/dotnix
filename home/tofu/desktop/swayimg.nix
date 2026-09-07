{ ... }:

{
  programs.swayimg = {
    enable = true;

    settings = {
      general = {
        mode = "viewer";
        size = "1280,720";
        overlay = "no";
        decoration = "yes";
      };

      viewer = {
        window = "#2c2c2eff";
        scale = "fit";
        loop = "yes";
        preload = "1";
      };

      gallery = {
        size = "200";
        aspect = "fill";
        pstore = "yes";
      };

      list = {
        order = "alpha";
        all = "yes";
        fsmon = "yes";
      };

      info = {
        show = "yes";
        info_timeout = "5";
      };

      "keys.viewer" = {
        Left = "prev_file";
        Right = "next_file";
        Space = "next_file";
        Prior = "prev_file";
        Next = "next_file";
        Equal = "zoom +10";
        Plus = "zoom +10";
        Minus = "zoom -10";
        BackSpace = "zoom optimal";
        "Ctrl+ScrollUp" = "zoom +10 mouse";
        "Ctrl+ScrollDown" = "zoom -10 mouse";
        MouseLeft = "drag";
        f = "fullscreen";
        s = "mode slideshow";
        Return = "mode gallery";
        bracketleft = "rotate_left";
        bracketright = "rotate_right";
        Escape = "exit";
        q = "exit";
      };

      "keys.gallery" = {
        Left = "step_left";
        Right = "step_right";
        Up = "step_up";
        Down = "step_down";
        Return = "mode viewer";
        s = "mode slideshow";
        f = "fullscreen";
        Escape = "exit";
        q = "exit";
        MouseLeft = "mode viewer";
      };

      "keys.slideshow" = {
        Space = "pause";
        Return = "mode";
        Escape = "exit";
        q = "exit";
      };
    };
  };
}
