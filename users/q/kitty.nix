{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    package = pkgs.unstable.kitty;
    font = {
      name = "VictorMono NerdFont";
      size = 15;
    };
    settings = {
      confirm_os_window_close = 0;
    };
  };
}
