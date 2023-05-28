{lib, ...}: {
  imports = [
    (import ./disk.nix {
      inherit lib;
      disks = ["/dev/vda"];
    })
    ./boot.nix
    ./persistence.nix
    ../../users/q/default.nix
  ];

  networking.hostName = "gate";
  system.stateVersion = "22.11";
}
