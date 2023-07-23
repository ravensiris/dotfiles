{
  description = "ravensiris' dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    nur.url = "github:nix-community/NUR";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    impermanence,
    disko,
    nur,
    devenv,
    agenix,
    ...
  }: let
    user = "q";
  in {
	homeManagerConfigurations = {
		q = home-manager.lib.homeManagerConfiguration {
			inherit inputs nixpkgs home-manager impermanence disko user nur devenv agenix;
			configuration = {
				home.stateVersion = "23.05";
				imports = [
					./users/q
				];
			};
		};
	};


    nixosConfigurations = (
      import ./hosts {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs home-manager impermanence disko user nur devenv agenix;
      }
    );
  };
}
