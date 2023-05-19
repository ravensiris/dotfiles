{
  inputs = {
    haumea = {
      url = "github:nix-community/haumea/v0.2.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nix-community/nixpkgs.lib";
  };

  outputs = { self, haumea, nixpkgs }: {
    lib = haumea.lib.load {
      src = ./src;
      inputs = {
        inherit (nixpkgs) lib;
      };
    };
  };
}
