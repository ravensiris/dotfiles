{
  lib,
  super,
  disko,
  dropOverrides,
  ...
}: let
  hostModules =
    lib.forEach
    (lib.attrValues
      (lib.filterAttrs
        (n: v: n != "default")
        super))
    (x: dropOverrides x);
in
  lib.nixosSystem {
    modules =
      [
        disko.nixosModules.disko
      ]
      ++ hostModules;
    system = "x86_64-linux";
  }
