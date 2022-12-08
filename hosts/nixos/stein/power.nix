{ config, lib, pkgs, ... }:

{
  powerManagement.powerDownCommands = ''
    ${pkgs.kmod}/bin/rmmod ath11k_pci
  '';
  powerManagement.powerUpCommands = ''
    ${pkgs.kmod}/bin/modprobe ath11k_pci
    ${pkgs.systemd}/bin/systemctl restart wpa_supplicant.service
  '';
}
