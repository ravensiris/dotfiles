{
  description = "ravensiris' dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/23.05";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    impermanence.url = "github:nix-community/impermanence";
    nur.url = "github:nix-community/NUR";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };


  outputs = inputs @ {
    nixpkgs,
    home-manager,
    impermanence,
    disko,
    nur,
    ...
  }: let
    user = "q";
  in {
    nixosConfigurations = (
      import ./hosts {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs home-manager impermanence disko user nur;
      }
    );
  };
}
