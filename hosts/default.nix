{
  lib,
  disko,
  home-manager,
  impermanence,
  ...
}: {
  gate = lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      home-manager.nixosModules.home-manager
      impermanence.nixosModules.home-manager
      disko.nixosModules.disko
      ./gate
    ];
  };
}
