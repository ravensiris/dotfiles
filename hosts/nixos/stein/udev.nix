{ config, lib, pkgs, ... }:

{
    services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="0a12", ATTRS{idProduct}=="4003", MODE="0666"
    '';
}
