{ config, lib, pkgs, ... }:

{
  environment.persistence."/nix/persist" = {
    directories = [
      "/var/lib/docker"
    ];
  };
}
