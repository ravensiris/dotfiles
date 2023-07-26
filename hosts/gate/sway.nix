{pkgs, ...}:{
  environment.systemPackages = with pkgs;
    [
      swaynotificationcenter
      xdg-utils
      glib
      dracula-theme # gtk themeracula-theme # gtk theme
      gnome3.adwaita-icon-theme # default gnome cursors
      grim # screenshot functionality
      slurp # screenshot functionality
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      gnome3.adwaita-icon-theme # default gnome cursors
      xdg-desktop-portal-wlr
      xorg.xeyes
    ];

  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "2";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };

  programs.sway = {
    enable = true;
  };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
    ];
  };

  security.polkit.enable = true;
  security.pam.services.swaylock.text = ''
    # Account management.
    account required pam_unix.so
    # Authentication management.
    auth sufficient pam_unix.so   likeauth try_first_pass
    auth required pam_deny.so
    # Password management.
    password sufficient pam_unix.so nullok sha512
    # Session management.
    session required pam_env.so conffile=/etc/pam/environment readenv=0
    session required pam_unix.so
  '';

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "sway"; # https://github.com/emersion/xdg-desktop-portal-wlr/issues/20
    XDG_SESSION_TYPE = "wayland"; # https://github.com/emersion/xdg-desktop-portal-wlr/pull/11
  };

}
