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
      home-manager.nixosModules.home-manager
      {
        nixpkgs.overlays = [nur.overlay];
      }
      disko.nixosModules.disko
      nur.nixosModules.nur
      agenix.nixosModules.default
      ./gate
    ];
  };
}
