{
  lib,
  disko,
  home-manager,
  impermanence,
  nur,
  devenv,
  agenix,
  ...
}: {
  gate = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit impermanence devenv agenix;};
    modules = [
      impermanence.nixosModules.impermanence
      disko.nixosModules.disko
      nur.nixosModules.nur
      agenix.nixosModules.default
      ./gate
      home-manager.nixosModules.home-manager
      {
        nixpkgs.overlays = [nur.overlay];
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        home-manager.users.q = import ../users/q;
		home-manager.extraSpecialArgs = {
			inherit impermanence;
		};
      }
    ];
  };
}
