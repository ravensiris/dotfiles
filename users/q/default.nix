{
  pkgs,
  impermanence,
  config,
  ...
}: {
  home.packages = with pkgs; [
    htop
    qbittorrent
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

  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      autoload
    ];
    bindings = {
      "CTRL+1" = ''no-osd change-list glsl-shaders set "${pkgs.anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode A (HQ)"'';
      "CTRL+2" = ''no-osd change-list glsl-shaders set "${pkgs.anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_Soft_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode B (HQ)"'';
      "CTRL+3" = ''no-osd change-list glsl-shaders set "${pkgs.anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode C (HQ)"'';
      "CTRL+4" = ''no-osd change-list glsl-shaders set "${pkgs.anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_M.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode A+A (HQ)"'';
      "CTRL+5" = ''no-osd change-list glsl-shaders set "${pkgs.anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_Soft_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_Soft_M.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode B+B (HQ)"'';
      "CTRL+6" = ''no-osd change-list glsl-shaders set "${pkgs.anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_M.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode C+A (HQ)"'';
      "CTRL+0" = ''no-osd change-list glsl-shaders clr ""; show-text "GLSL shaders cleared"'';
    };
  };

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
      ".floorp"
    ];
  };

  home.file = {
    ".emacs.d".source = config.lib.file.mkOutOfStoreSymlink "/home/q/.config/emacs";
  };

  home.stateVersion = "24.05";
}
