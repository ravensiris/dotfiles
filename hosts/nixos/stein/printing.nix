{ config, lib, pkgs, ... }:

{
  environment.persistence."/nix/persist" = {
    directories = [
      "/var/lib/cups"
    ];
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint hplip ];
  };
}
