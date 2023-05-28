{
  description = "ravensiris' dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/22.11";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
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
