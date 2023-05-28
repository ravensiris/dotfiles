{
  lib,
  disko,
  home-manager,
  impermanence,
  ...
}: {
  gate = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit impermanence; };
    modules = [
      home-manager.nixosModules.home-manager
      {
        inherit impermanence;
      }
      disko.nixosModules.disko
      ./gate
    ];
  };
}
