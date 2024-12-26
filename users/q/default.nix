{
  pkgs,
  impermanence,
  nix-index-database,
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
    kdenlive
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
    orca-slicer
    freecad
    usbutils
    openscad
    persepolis
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
  ];

  programs.nix-index.enable = true;

  services.udiskie.enable = true;

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  xdg.enable = true;
  home.persistence."/nix/persist/home/q".allowOther = true;
  home.persistence."/nix/persist/home/q" = {
    directories = [
      ".cache"
      ".config/Element"
      ".floorp"
      ".config/vesktop"
      ".config/feishin"
      ".local/share/krita"
      ".config/OrcaSlicer"
      ".local/share/orca-slicer"
      ".config/FreeCAD"
      ".config/OpenSCAD"
    ];
  };

  home.stateVersion = "24.05";
}
