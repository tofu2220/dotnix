{ ... }:

{
  programs.helix = {
    enable = true;
    ignores = [
      "!.gitignore"
    ];
    settings = {
      theme = "catppuccin_mocha";

      keys.normal.d.d = [
        "extend_line_below"
        "delete_selection"
      ];

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
