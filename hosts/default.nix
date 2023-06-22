{
  lib,
  disko,
  home-manager,
  impermanence,
  nur,
  ...
}: {
  gate = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit impermanence;};
    modules = [
      impermanence.nixosModules.impermanence
      home-manager.nixosModules.home-manager {
	nixpkgs.overlays = [ nur.overlay ];
      }
      disko.nixosModules.disko
      nur.nixosModules.nur
      ./gate
    ];
  };
}
