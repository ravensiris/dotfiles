{
  description = "My Ubuntu Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    nixgl.url = "github:nix-community/nixGL";
    kotkowo.url = "git+file:///home/q/Projects/kotkowo/";
  };
  outputs = {
    nixpkgs,
    home-manager,
    nur,
    nixgl,
    kotkowo,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      system = system;
      config.allowUnfree = true;
    };

    # NOTE: already using unstable - this is for compatibility
    unstableOverlay = final: prev: {
      unstable = pkgs;
    };
  in {
    homeConfigurations = {
      q = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./home.nix
          {nixpkgs.overlays = [nur.overlay unstableOverlay nixgl.overlay];}
          kotkowo.nixosModule
        ];
      };
    };
  };
}
