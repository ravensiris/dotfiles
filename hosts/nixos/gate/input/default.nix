{ config, lib, pkgs, ... }:

{
  services.xserver.libinput = {
    enable = true;
    mouse = {
      accelProfile = "flat";
      accelSpeed = "0.0";
    };
  };
}
