{ pkgs, ... }:

{
  home.packages = [
    pkgs.libreoffice-fresh

    # Add spellcheck dictionaries here later:
    # pkgs.hunspell
    # pkgs.hunspellDicts.en_US
  ];
}
