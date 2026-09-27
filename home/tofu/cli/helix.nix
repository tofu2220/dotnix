{ ... }:

{
  programs.helix = {
    enable = true;

    settings = {
      theme = "catppuccin_mocha";

      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };
  };
}
