{...}: let
  gigabyteMonitor = "GIGA-BYTE TECHNOLOGY CO. LTD. M28U 22110B009190";
  lgMonitor = "LG Electronics LG SDQHD 205NTNH5W679";
in {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 3;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "480, 80";
          position = "0, -80";
          monitor = gigabyteMonitor;
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = "<span foreground=\"##cad3f5\">Password...</span>";
          shadow_passes = 2;
        }
      ];
    };
  };
}
