{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/22.11";
    haumea = {
      url = "github:nix-community/haumea/v0.2.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    haumea,
    nixpkgs,
    disko,
    ...
  }: let
    nlib = nixpkgs.lib;
    takeHosts = nixosConfigurations: nlib.mapAttrs (n: v: v.default) nixosConfigurations;
  in {
    lib = haumea.lib.load {
      src = ./src;
      loader = haumea.lib.loaders.callPackage;
      inputs = {
        inherit (nixpkgs) lib;
        inherit disko;
        dropOverrides = thing:
          nlib.filterAttrs
          (n: v: n != "override" && n != "overrideDerivation")
          thing;
      };
    };

    nixosConfigurations = takeHosts self.lib.hosts;
  };
}
