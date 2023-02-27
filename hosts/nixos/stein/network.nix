{ config, lib, pkgs, ... }:

{
  networking.networkmanager.enable = true;

  # extend i3status-rust with network
  home-manager.users.q.programs.i3status-rust.bars.default.blocks = [
    {
      block = "networkmanager";
      on_click = "${pkgs.kitty}/bin/kitty -e nmtui --start-as fullscreen";
      # interface_name_exclude = ["br\-[0-9a-f]{12}" "docker\d+" "vboxnet\d+"];
      interface_name_include = [ "wlp1s0" ];
      ap_format = "{ssid}({strength})";
      device_format = "{icon}{ap}";
      theme_overrides = {
        idle_bg = "#6c71c4";
        idle_fg = "#002b36";
      };
    }
  ];
}
