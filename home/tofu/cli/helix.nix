{ ... }:

{
  programs.helix = {
    enable = true;

    settings = {
      theme = "tokyonight";

      editor.cursor-shape = {
        normal = "block"; # khối
        insert = "bar"; # vạch dọc
        select = "underline"; # gạch dưới
      };
    };
  };
}
