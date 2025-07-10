{
  pkgs,
  impermanence,
  nix-index-database,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    htop
    imv
    p7zip
    gimp
    inkscape
    element-desktop
    nvd
    libreoffice
    khinsider
    nmap
    obs-studio
    flacon
    sox
    insomnia
    brave
    floorp
    sweethome3d.application
    psmisc
    vesktop
    feishin
    waifu2x-converter-cpp
    backgroundremover
    unstable.orca-slicer
    freecad
    usbutils
    openscad
    foliate
    thunderbird-latest
    birdtray
    remmina
    ungoogled-chromium
  ];

  xdg.mimeApps = let
    assocs = {
      "application/vnd.ms-3mfdocument" = ["OrcaSlicer.desktop"];
      "model/3mf" = ["OrcaSlicer.desktop"];
      "model/stl" = ["OrcaSlicer.desktop"];
      "x-scheme-handler/http" = ["floorp.desktop"];
      "x-scheme-handler/https" = ["floorp.desktop"];
      "x-scheme-handler/chrome" = ["floorp.desktop"];
      "text/html" = ["floorp.desktop"];
      "application/x-extension-htm" = ["floorp.desktop"];
      "application/x-extension-html" = ["floorp.desktop"];
      "application/x-extension-shtml" = ["floorp.desktop"];
      "application/xhtml+xml" = ["floorp.desktop"];
      "application/x-extension-xhtml" = ["floorp.desktop"];
      "application/x-extension-xht" = ["floorp.desktop"];
    };
  in {
    enable = true;
    associations.added = assocs;
    defaultApplications = assocs;
  };

  home.sessionVariables = {
    QT_SCALE_FACTOR = "1.7";
  };

  xdg.configFile."distrobox/distrobox.conf" = {
    source = ./distrobox.conf;
  };

  xdg.desktopEntries.brave-browser = {
    name = "Brave Web Browser";
    icon = "brave-browser";
    exec = "${pkgs.brave}/bin/brave --force-device-scale-factor=2.0";
    terminal = false;
    type = "Application";
    categories = ["Network" "WebBrowser"];
  };

  imports = [
    nix-index-database.hmModules.nix-index
    impermanence.nixosModules.home-manager.impermanence
    ./neovim
    ./hyprland.nix
    ./firefox.nix
    ./fish.nix
    ./kitty.nix
    ./gpg.nix
    ./git.nix
    ./direnv.nix
    ./ssh.nix
    ./music.nix
    ./media.nix
    ./android-studio.nix
    ./cursor.nix
  ];

  programs.nix-index.enable = true;

  services.udiskie.enable = true;

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
    "org/gnome/desktop/interface" = {
      # NOTE: no idea if this ever worked/works
      scaling-factor = lib.hm.gvariant.mkUint32 2;
      color-scheme = "prefer-dark";
    };
  };

  xdg.enable = true;

  xdg.desktopEntries.floorp-work = {
    name = "Floorp Work";
    genericName = "Web Browser";
    exec = "floorp -P Work %U";
    terminal = false;
    categories = ["Application" "Network" "WebBrowser"];
    mimeType = ["text/html" "text/xml"];
  };

  home.persistence."/nix/persist/home/q".allowOther = true;
  home.persistence."/nix/persist/home/q" = {
    directories = [
      ".config/Element"
      ".floorp"
      ".config/vesktop"
      ".config/feishin"
      ".local/share/krita"
      ".config/OrcaSlicer"
      ".local/share/orca-slicer"
      ".local/share/FreeCAD"
      ".config/FreeCAD"
      ".config/OpenSCAD"
      ".thunderbird"
      ".config/birdtray"
      ".config/BraveSoftware/Brave-Browser"
      ".config/remmina"
      ".local/share/remmina"
      ".config/chromium"
    ];
  };

  home.stateVersion = "24.05";
}
