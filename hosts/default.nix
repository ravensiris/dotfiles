{
  lib,
  inputs,
  nixpkgs,
  home-manager,
  disko,
  user,
  ...
}: {
  gate = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit user;
    };
    modules = [
      ./configuration.nix
      disko.nixosModules.disko
      ./gate
    ];
  };
}
