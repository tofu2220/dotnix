{ ... }:

{
  programs.helix = {
    enable = true;

    settings = {
      theme = "base16_default";

      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };
  };
}
