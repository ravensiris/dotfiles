{
  lib,
  disko,
  home-manager,
  impermanence,
  nur,
  agenix,
  nixpkgs-unstable,
  wfetch,
  ...
}: let
  unstableOverlay = final: prev: {
    unstable = nixpkgs-unstable.legacyPackages.${prev.system};
  };
  unstableModule = {
    config,
    pkgs,
    ...
  }: {nixpkgs.overlays = [unstableOverlay];};
  wfetchOverlay = final: prev: {
    wfetch = wfetch.packages.${prev.system}.default;
  };
in {
  gate = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit impermanence agenix;};
    modules = [
      impermanence.nixosModules.impermanence
      disko.nixosModules.disko
      nur.nixosModules.nur
      agenix.nixosModules.default
      unstableModule
      {nixpkgs.overlays = [wfetchOverlay];}
      ./gate
      home-manager.nixosModules.home-manager
      (import ../pkgs)
      {
        nixpkgs.overlays = [nur.overlay unstableOverlay];
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
