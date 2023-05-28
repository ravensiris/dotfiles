{
  lib,
  disko,
  home-manager,
  ...
}: {
  gate = lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      home-manager.nixosModules.home-manager
      disko.nixosModules.disko
      ./gate
    ];
  };
}
