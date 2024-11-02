{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    font = {
      name = "VictorMono NerdFont";
      size = 15;
    };
    settings = {
      confirm_os_window_close = 0;
    };
  };
}
