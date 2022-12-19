{ config, lib, pkgs, ... }:

{
  environment.persistence."/nix/persist" = {
    directories = [
      "/var/lib/docker"
      "/etc/NetworkManager/system-connections/"
    ];
    users.q.directories = [ "Projects" ".wine" ".local/share/lutris" "Games" ".config/lutris" "Pictures" ];
  };

}
