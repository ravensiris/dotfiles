{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
  ];

  environment.systemPackages = with pkgs; [
    brightnessctl
    neovim
    tenacity
    gnupg
    virtualbox
    wineWowPackages.staging
    winetricks
    lutris
    pcsx2
    qbittorrent
    easyeffects
    libreoffice
    gimp
    inkscape
  ];
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "q" ];

  programs.steam = {
    enable = true;
    # remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    # dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
}
