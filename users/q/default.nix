{
  pkgs,
  impermanence,
  nix-index-database,
  ...
}: let
  my-comfyui = pkgs.comfyuiPackages.comfyui.override {
    extensions = [
      pkgs.comfyuiPackages.extensions.acly-inpaint
      pkgs.comfyuiPackages.extensions.acly-tooling
      pkgs.comfyuiPackages.extensions.cubiq-ipadapter-plus
      pkgs.comfyuiPackages.extensions.fannovel16-controlnet-aux
    ];

    commandLineArgs = [
      "--preview-method"
      "auto"
    ];
  };
in {
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
    unstable.feishin
    waifu2x-converter-cpp
    backgroundremover
    my-comfyui
    comfyuiPackages.krita-with-extensions
    bambu-studio
  ];

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
      ".config/Element"
      ".floorp"
      ".config/vesktop"
      ".config/feishin"
      ".local/share/krita"
      ".config/BambuStudio"
    ];
    files = [".config/mimeapps.list"];
  };

  home.stateVersion = "24.05";
}
