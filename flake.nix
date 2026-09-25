{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
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
            { nixpkgs.overlays = [ unstableOverlay ]; }
            host
          ];

          specialArgs = { inherit home-manager; };
        };
    in
    {
      overlays.default = unstableOverlay;
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;

      nixosConfigurations = {
        dell = mkHost ./hosts/dell;
        t14 = mkHost ./hosts/t14;
      };
    };
}
