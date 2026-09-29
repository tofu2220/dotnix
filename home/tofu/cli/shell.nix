{ ... }:

{
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        set -g fish_greeting
      '';
    };

    starship = {
      enable = true;
      presets = [ "nerd-font-symbols" ];

      settings = {
        add_newline = false;
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    zoxide = {
      enable = true;
    };
  };
}
