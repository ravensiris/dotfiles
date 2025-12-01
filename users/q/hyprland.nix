{
  pkgs,
  hyprland,
  lib,
  ...
}: let
  gigabyteWallpaper = builtins.fetchurl rec {
    name = "${sha256}.jpg";
    url = "https://cdn.donmai.us/original/53/5f/__portia_original_drawn_by_gogalking__535f5c82b75ca89e51638502eab271a3.jpg";
    sha256 = "0qq6bflwdpysg3rrn3rh6yp81fkhlisjkgay9fiz2gcm6wv58y1b";
  };

  lgWallpaper = builtins.fetchurl rec {
    name = "${sha256}.jpg";
    url = "https://cdn.donmai.us/original/cd/59/__ofelia_original_drawn_by_gogalking__cd5972890522ff309cbf8bff23e68e54.jpg";
    sha256 = "0i6rv1rx5gaqnvzaa0z4riwiqc47fxf93qymqh5gzy8w5ykxa8vg";
  };
in {
  imports = [
    ./themes/rose-pine.nix
    ./hyprland/waybar.nix
    ./hyprland/hypridle.nix
    ./hyprland/hyprlock.nix
  ];

  programs.fuzzel.enable = true;

  services.hyprpolkitagent.enable = true;
  services.gnome-keyring.enable = true;

  home.packages = with pkgs; [
    hyprpaper
  ];

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "${gigabyteWallpaper}"
        "${lgWallpaper}"
      ];
      wallpaper = [
        "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M28U 22110B009190,${gigabyteWallpaper}"
        "desc:LG Electronics LG SDQHD 205NTNH5W679,${lgWallpaper}"
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "${pkgs.kitty}/bin/kitty";
      general = {
        gaps_out = "4,2,2,2";
      };
      input = {
        kb_layout = "pl";
      };

      ecosystem = {
        no_update_news = true;
      };

      monitor = [
        "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M28U 22110B009190,highrr,0x504,1"
        "desc:LG Electronics LG SDQHD 205NTNH5W679,preferred,3840x0,1"
        ",preferred,auto,1"
      ];
      workspace = lib.lists.flatten [
        "1, monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. M28U 22110B009190, default:true, persistent:true"

        (lib.lists.forEach
          (lib.lists.range 2 6)
          (x: "${toString x}, monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. M28U 22110B009190"))

        (lib.lists.forEach
          (lib.lists.range 7 8)
          (x: "${toString x}, monitor:desc:LG Electronics LG SDQHD 205NTNH5W679"))

        "9, monitor:desc:LG Electronics LG SDQHD 205NTNH5W679, default:true, persistent:true"
      ];
      exec-once = [
        "${pkgs.hyprland}/bin/hyprctl setcursor Bibata-Modern-Classic 32"
        "${pkgs.unstable.vesktop}/bin/vesktop"
        "${pkgs.element-desktop}/bin/element-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland --hidden"
      ];
      bindm = [
        # move / resize with mouse
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      bind = let
        workspaceBinds = (
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );
      in
        [
          # window management
          "$mod + SHIFT, Q, killactive"
          "$mod + SHIFT, Space, togglefloating"
          "$mod, F, fullscreen"

          # focus
          "$mod, N, movefocus, l"
          "$mod, E, movefocus, d"
          "$mod, I, movefocus, u"
          "$mod, O, movefocus, r"

          # move windows
          "$mod + Shift, N, movewindow, l"
          "$mod + Shift, E, movewindow, d"
          "$mod + Shift, I, movewindow, u"
          "$mod + Shift, O, movewindow, r"

          # applications
          "$mod, Return, exec, $terminal"
          "$mod, D, exec, ${pkgs.fuzzel}/bin/fuzzel --show-actions"

          # utility
          "$mod, P, exec, ${pkgs.grimblast}/bin/grimblast copy area"
          "$mod, L, exec, ${pkgs.hyprlock}/bin/hyprlock"
        ]
        ++ workspaceBinds;
    };
  };
}
