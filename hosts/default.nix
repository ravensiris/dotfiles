{
  lib,
  disko,
  ...
}: {
  gate = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
    };
    modules = [
      disko.nixosModules.disko
      ./gate
    ];
  };
}
