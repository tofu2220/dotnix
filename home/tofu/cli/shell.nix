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
      enableFishIntegration = true;
      presets = [ "nerd-font-symbols" ];

      settings = {
        add_newline = false;
      };
    };

    direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
