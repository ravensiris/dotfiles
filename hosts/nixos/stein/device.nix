{ config, lib, pkgs, ... }:

{
  services.xserver.libinput.enable = true;

  # extend i3status-rust with battery
  home-manager.users.q.programs.i3status-rust.bars.default.blocks = [
    {
      block = "battery";
    }
  ];
}
