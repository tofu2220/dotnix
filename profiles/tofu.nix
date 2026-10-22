{ home-manager, noctalia, pkgs, ... }:

{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  programs.fish.enable = true;

  users.users.tofu = {
    isNormalUser = true;
    description = "Nguyen Thanh Phuc";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit noctalia; };
    users.tofu = import ../home/tofu;
  };
}
