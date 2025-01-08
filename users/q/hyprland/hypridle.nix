{pkgs, ...}: let
  gigabyteMonitor = "GIGA-BYTE TECHNOLOGY CO. LTD. M28U 22110B009190";
  lgMonitor = "LG Electronics LG SDQHD 205NTNH5W679";
in {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "${pkgs.hyprlock}/bin/hyprlock";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "${pkgs.hyprlock}/bin/hyprlock";
        }
        {
          timeout = 600;
          on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
