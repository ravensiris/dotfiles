{lib, ...}: {
  imports = [
    (import ./disk.nix {
      inherit lib;
      disks = ["/dev/vda"];
    })
    ./boot.nix
    ./persistence.nix
    ./users.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  networking.hostName = "gate";
  system.stateVersion = "22.11";
}
