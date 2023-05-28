{
  lib,
  disko,
  home-manager,
  impermanence,
  ...
}: {
  gate = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit impermanence;};
    modules = [
      impermanence.nixosModules.default
      home-manager.nixosModules.home-manager
      disko.nixosModules.disko
      ./gate
    ];
  };
}
