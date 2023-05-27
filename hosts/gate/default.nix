{
  lib,
  ...
}: {
  imports = [
    (import ./disk.nix {
      inherit lib;
      disks = ["/dev/vda"];
    })
    ./boot.nix
    ../../users/q/default.nix
  ];

  system.stateVersion = "22.11";
}
