{
  self,
  lib,
  disko,
  home-manager,
  impermanence,
  nur,
  agenix,
  nixpkgs-unstable,
  wfetch,
  nix-index-database,
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
    specialArgs = {inherit impermanence agenix nix-index-database;};
    modules = [
      impermanence.nixosModules.impermanence
      disko.nixosModules.disko
      nur.modules.nixos.default
      agenix.nixosModules.default
      unstableModule
      {nixpkgs.overlays = [wfetchOverlay];}
      {imports = [../modules/kvmfr.nix ../modules/s3fs.nix];}
      ./gate
      home-manager.nixosModules.home-manager
      (import ../pkgs)
      {
        nixpkgs.overlays = [nur.overlays.default unstableOverlay];
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        home-manager.users.q = import ../users/q;
        home-manager.extraSpecialArgs = {
          inherit impermanence nix-index-database;
        };
      }
    ];
  };
}
