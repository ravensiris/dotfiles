{...}: {
  environment.persistence."/nix/persist" = {
    directories = [
      "/var/lib/libvirt"
      "/var/lib/docker"
      "/var/lib/cups"
      "/var/lib/private/navidrome"
    ];
  };

  programs.fuse.userAllowOther = true;
}
