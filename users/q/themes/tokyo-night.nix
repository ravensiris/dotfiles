{pkgs, ...}: {
  # using storm variant for everything
  programs.fuzzel = {
    settings = {
      colors = {
        background = "1f2335ff";
        text = "c0caf5ff";
        match = "2ac3deff";
        selection = "363d59ff";
        selection-match = "2ac3deff";
        selection-text = "c0caf5ff";
        border = "29a4bdff";
      };
    };
  };

  programs.kitty.extraConfig = builtins.concatStringsSep "\n" [
    "background_opacity 0.9"
    "foreground #a9b1d6"
    "background #1a1b26"
    "selection_background #2e3c64"
    "selection_foreground #c0caf5"
    "url_color #73daca"
    "cursor #c0caf5"
    "cursor_text_color #24283b"
    # Tabs
    "active_tab_background #7aa2f7"
    "active_tab_foreground #1f2335"
    "inactive_tab_background #292e42"
    "inactive_tab_foreground #545c7e"
    # Windows
    "active_border_color #7aa2f7"
    "inactive_border_color #292e42"
    # normal
    "color0 #1d202f"
    "color1 #f7768e"
    "color2 #9ece6a"
    "color3 #e0af68"
    "color4 #7aa2f7"
    "color5 #bb9af7"
    "color6 #7dcfff"
    "color7 #a9b1d6"
    # bright
    "color8 #414868"
    "color9 #f7768e"
    "color10 #9ece6a"
    "color11 #e0af68"
    "color12 #7aa2f7"
    "color13 #bb9af7"
    "color14 #7dcfff"
    "color15 #c0caf5"
    # extended colors
    "color16 #ff9e64"
    "color17 #db4b4b"
  ];

  xdg.configFile."fish/themes/tokyonight.theme" = {
    source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/fish_themes/tokyonight_storm.theme";
      sha256 = "sha256-9MEgrt6LUSoFJuzub3v7VkyQ+GTbZWPWz6S+Rw3/g04=";
    };
  };
}
