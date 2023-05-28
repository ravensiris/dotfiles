{...}:
{
  environment.persistence."/nix/persist" = {
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
}
