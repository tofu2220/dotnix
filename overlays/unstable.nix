{ nixpkgs-unstable }:

final: _prev:

{
  unstable = import nixpkgs-unstable {
    inherit (final.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
}
