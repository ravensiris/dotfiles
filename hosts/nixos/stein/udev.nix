{ config, lib, pkgs, ... }:

{
    services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="0a12", ATTRS{idProduct}=="4003", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="0a12", ATTRS{idProduct}=="4007", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="0a12", ATTRS{idProduct}=="4010", MODE="0666"
    '';
}
