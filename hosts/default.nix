{
  lib,
  disko,
  home-manager,
  impermanence,
  nur,
  devenv,
  agenix,
  nixpkgs-unstable,
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
in {
  gate = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit impermanence devenv agenix;};
    modules = [
      impermanence.nixosModules.impermanence
      disko.nixosModules.disko
      nur.nixosModules.nur
      agenix.nixosModules.default
      unstableModule
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

  stein = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit impermanence devenv agenix;};
    modules = [
      impermanence.nixosModules.impermanence
      disko.nixosModules.disko
      nur.nixosModules.nur
      agenix.nixosModules.default
      unstableModule
      ./stein
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
