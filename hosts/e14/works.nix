{ pkgs, ... }:

{
  home.packages = with pkgs; [
    libreoffice-fresh
    unstable.claude-code
    unstable.brave-origin # For PWA Teams, Outlook

    # Add spellcheck dictionaries here later:
    # pkgs.hunspell
    # pkgs.hunspellDicts.en_US
  ];
}
