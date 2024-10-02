{
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

  lookingGlassOverlay = final: prev: {
    linuxPackages_latest = prev.linuxPackages_latest.extend (kfinal: kprev: {
      kvmfr = prev.linuxPackages_latest.kvmfr.overrideAttrs (old: {
        patches = [
          # fix build for linux-6_10
          (prev.fetchpatch {
            url = "https://github.com/gnif/LookingGlass/commit/7305ce36af211220419eeab302ff28793d515df2.patch";
            hash = "sha256-97nZsIH+jKCvSIPf1XPf3i8Wbr24almFZzMOhjhLOYk=";
            stripLen = 1;
          })

          # securtiy patch for potential buffer overflow
          # https://github.com/gnif/LookingGlass/issues/1133
          (prev.fetchpatch {
            url = "https://github.com/gnif/LookingGlass/commit/3ea37b86e38a87ee35eefb5d8fcc38b8dc8e2903.patch";
            hash = "sha256-Kk1gN1uB86ZJA374zmzM9dwwfMZExJcix3hee7ifpp0=";
            stripLen = 1;
          })
        ];
      });
    });

    looking-glass-client = prev.looking-glass-client.overrideAttrs (old: {
      patches = [
        (prev.fetchpatch {
          url = "https://github.com/gnif/LookingGlass/commit/20972cfd9b940fddf9e7f3d2887a271d16398979.patch";
          hash = "sha256-CqB8AmOZ4YxnEsQkyu/ZEaun6ywpSh4B7PM+MFJF0qU=";
          stripLen = 1;
        })
      ];
    });
  };
in {
  gate = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit impermanence agenix nix-index-database;};
    modules = [
      impermanence.nixosModules.impermanence
      disko.nixosModules.disko
      nur.nixosModules.nur
      agenix.nixosModules.default
      unstableModule
      {nixpkgs.overlays = [wfetchOverlay lookingGlassOverlay];}
      {imports = [../modules/kvmfr.nix];}
      ./gate
      home-manager.nixosModules.home-manager
      (import ../pkgs)
      {
        nixpkgs.overlays = [nur.overlay unstableOverlay];
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
