{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    brightnessctl
    neovim
    tenacity
    gnupg
  ];
}
