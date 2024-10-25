{
  pkgs,
  hyprland,
  lib,
  ...
}: let
  hyprlandPkg = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
in {
  imports = [
    ./themes/tokyo-night.nix
    ./hyprland/waybar.nix
  ];

  programs.fuzzel.enable = true;

  home.packages = with pkgs; [
    hyprpaper
  ];

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 32;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };
    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "/home/q/Pictures/Wallpapers/GIGA-BYTE TECHNOLOGY CO., LTD. M28U 22110B009190[3840x2160]/__sin_mal_honkai_and_1_more_drawn_by_sin_mal0909__e4844fb47fccc09db25da93fe60dac7a.png"
        "/home/q/Pictures/Wallpapers/LG Electronics LG SDQHD 205NTNH5W679[2560x2880]/__ninomae_ina_nis_takodachi_and_ninomae_ina_nis_hololive_and_1_more_drawn_by_happyongdal__748043200955892f31bf77c2abc008c8.png"
      ];
      wallpaper = [
        "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M28U 22110B009190,/home/q/Pictures/Wallpapers/GIGA-BYTE TECHNOLOGY CO., LTD. M28U 22110B009190[3840x2160]/__sin_mal_honkai_and_1_more_drawn_by_sin_mal0909__e4844fb47fccc09db25da93fe60dac7a.png"
        "desc:LG Electronics LG SDQHD 205NTNH5W679,/home/q/Pictures/Wallpapers/LG Electronics LG SDQHD 205NTNH5W679[2560x2880]/__ninomae_ina_nis_takodachi_and_ninomae_ina_nis_hololive_and_1_more_drawn_by_happyongdal__748043200955892f31bf77c2abc008c8.png"
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprlandPkg;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "${pkgs.unstable.kitty}/bin/kitty";
      general = {
        gaps_out = "4,2,2,2";
      };
      input = {
        kb_layout = "pl";
      };
      monitor = [
        "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M28U 22110B009190,preferred,0x504,1"
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
        "${hyprlandPkg}/bin/hyprctl setcursor Bibata-Modern-Classic 32"
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
        ]
        ++ workspaceBinds;
    };
  };
}
