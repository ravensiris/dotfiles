{ config, lib, pkgs, ... }:

{
  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        blocks = [{
          block = "time";
          interval = 15;
          format = "%a %d/%m %R";
        }];
        icons = "awesome";
        theme = "solarized-dark";
      };
    };
  };
}
