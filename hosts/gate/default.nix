{lib, ...}: {
  imports = [
    (import ./disk.nix {
      inherit lib;
      disks = ["/dev/vda"];
    })
    ./boot.nix
    ../../users/q/default.nix
  ];

  environment.persistence."/nix/persist" = {
    enableDebugging = true;
    directories = [
      "/var/lib/libvirt"
      "/var/lib/docker"
      "/var/lib/cups"
      "/var/lib/private/navidrome"
    ];

    users.q.directories = [
      "Projects"
      "Documents"
      "Sync"
      ".config/syncthing"
      "Music"
    ];
  };

  programs.fuse.userAllowOther = true;

  system.stateVersion = "22.11";
}
