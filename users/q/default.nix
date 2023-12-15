{
  pkgs,
  impermanence,
  config,
  ...
}: {
  home.packages = with pkgs; [
    htop
    qbittorrent
    mpv
    imv
    p7zip
    gimp
    inkscape
    element-desktop
    nvd
    libreoffice
    khinsider
    nmap
  ];
  imports = [
    impermanence.nixosModules.home-manager.impermanence
    ./neovim
    ./sway.nix
    ./firefox.nix
    ./fish.nix
    ./kitty.nix
    ./gpg.nix
    ./git.nix
    ./direnv.nix
    ./ssh.nix
    ./music.nix
  ];

  services.easyeffects = {
    enable = true;
    preset = "HD800S";
  };

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
      ".config/Element"
      ".doom.d"
      ".config/emacs"
    ];
  };

  home.file = {
    ".emacs.d".source = config.lib.file.mkOutOfStoreSymlink "/home/q/.config/emacs";
  };

  home.stateVersion = "23.11";
}
