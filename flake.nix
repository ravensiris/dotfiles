{
  description = "ravensiris' dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/22.11";
    home-manager.url = "github:nix-community/home-manager";
    impermanence.url = "github:nix-community/impermanence";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    impermanence,
    disko,
    ...
  }: let
    user = "q";
  in {
    nixosConfigurations = (
      import ./hosts {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs home-manager impermanence disko user;
      }
    );
  };
}
