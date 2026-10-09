{ ... }:

{
  programs.helix = {
    enable = true;
    ignores = [
      "!.gitignore"
    ];
    settings = {
      theme = "catppuccin_mocha";

      editor = {
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
      };
    };
  };
}
