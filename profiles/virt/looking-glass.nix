{ pkgs, ... }:
{
  systemd.tmpfiles.rules = [ "f /dev/shm/looking-glass 0660 root libvirtd -" ];
  environment.systemPackages = with pkgs; [
    looking-glass-client
  ];
}
