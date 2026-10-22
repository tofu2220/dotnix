{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia.url = "github:noctalia-dev/noctalia/v5.3.0";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      noctalia,
      auto-cpufreq,
      ...
    }:
    let
      system = "x86_64-linux";
      unstableOverlay = import ./overlays/unstable.nix { inherit nixpkgs-unstable; };
      mkHost =
        host:
        nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            auto-cpufreq.nixosModules.default
            {
              nixpkgs.overlays = [
                unstableOverlay
              ];
            }
            host
          ];

          specialArgs = { inherit home-manager noctalia; };
        };
    in
    {
      overlays.default = unstableOverlay;
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;

      nixosConfigurations = {
        dell = mkHost ./hosts/dell;
        t14 = mkHost ./hosts/t14;
        e14 = mkHost ./hosts/e14;
      };
    };
}
