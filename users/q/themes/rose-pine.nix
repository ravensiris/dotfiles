{pkgs, ...}: let
  basePalette = {
    base = "#191724";
    surface = "#1f1d2e";
    overlay = "#26233a";
    muted = "#6e6a86";
    subtle = "#908caa";
    text = "#e0def4";
    love = "#eb6f92";
    gold = "#f6c177";
    rose = "#ebbcba";
    pine = "#31748f";
    foam = "#9ccfd8";
    iris = "#c4a7e7";
    highlightLow = "#21202e";
    highlightMed = "#403d52";
    highlightHigh = "#524f67";
  };
  moonPalette = {
    base = "#232136";
    surface = "#2a273f";
    overlay = "#393552";
    muted = "#6e6a86";
    subtle = "#908caa";
    text = "#e0def4";
    love = "#eb6f92";
    gold = "#f6c177";
    rose = "#ea9a97";
    pine = "#3e8fb0";
    foam = "#9ccfd8";
    iris = "#c4a7e7";
    highlightLow = "#2a283e";
    highlightMed = "#44415a";
    highlightHigh = "#56526e";
  };
in {
  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.rose-pine-cursor;
    name = "BreezeX-RosePine-Linux";
    size = 32;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.rose-pine-gtk-theme;
      name = "rose-pine";
    };
    iconTheme = {
      package = pkgs.rose-pine-icon-theme;
      name = "rose-pine";
    };
  };

  programs.fuzzel = {
    settings = {
      colors = let
        noHash = str: builtins.substring 1 (builtins.stringLength str) str;
      in
        builtins.builtins.mapAttrs (_: v: (noHash v) + "ff") {
          background = basePalette.base;
          text = basePalette.text;
          match = basePalette.foam;
          selection = basePalette.overlay;
          selection-match = basePalette.foam;
          selection-text = basePalette.text;
          border = basePalette.pine;
        };
    };
  };

  xdg.configFile."fish/themes/tokyonight.theme" = {
    source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/rose-pine/fish/refs/heads/main/themes/Ros%C3%A9%20Pine.theme";
      sha256 = "sha256-aRk1M8a3za36l6MNiOlD3PwVZqtXiv6I+s3WacqPDhw=";
    };
  };
  programs.kitty.extraConfig = builtins.concatStringsSep "\n" [
    "background_opacity 0.9"

    "foreground ${basePalette.text}"
    "background ${basePalette.base}"
    "selection_foreground ${basePalette.text}"
    "selection_background ${basePalette.highlightMed}"

    "cursor ${basePalette.highlightHigh}"
    "cursor_text_color ${basePalette.text}"

    "url_color ${basePalette.iris}"

    "active_tab_foreground ${basePalette.text}"
    "active_tab_background ${basePalette.overlay}"
    "inactive_tab_foreground ${basePalette.muted}"
    "inactive_tab_background ${basePalette.base}"

    "active_border_color ${basePalette.pine}"
    "inactive_border_color ${basePalette.highlightMed}"

    # black
    "color0 ${basePalette.overlay}"
    "color8 ${basePalette.muted}"

    # red
    "color1 ${basePalette.love}"
    "color9 ${basePalette.love}"

    # green
    "color2 ${basePalette.pine}"
    "color10 ${basePalette.pine}"

    # yellow
    "color3 ${basePalette.gold}"
    "color11 ${basePalette.gold}"

    # blue
    "color4 ${basePalette.foam}"
    "color12 ${basePalette.foam}"

    # magenta
    "color5 ${basePalette.iris}"
    "color13 ${basePalette.iris}"

    # cyan
    "color6 ${basePalette.rose}"
    "color14 ${basePalette.rose}"

    # white
    "color7 ${basePalette.text}"
    "color15 ${basePalette.text}"
  ];
}
