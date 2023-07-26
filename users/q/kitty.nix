{...}: {
  programs.kitty = {
    enable = true;
    font = {
      name = "VictorMono NerdFont";
      size = 18;
    };
    settings = {
      confirm_os_window_close = 0;
    };
    theme = "Dracula";
    extraConfig = builtins.concatStringsSep "\n" [
      "background_opacity 0.9"
    ];
  };
}
