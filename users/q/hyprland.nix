{
  pkgs,
  hyprland,
  lib,
  ...
}: let
  gigabyteWallpaper = builtins.fetchurl rec {
    name = "${sha256}.jpg";
    url = "https://cdn.donmai.us/original/f6/c3/__eishin_flash_and_smart_falcon_umamusume_drawn_by_yu_hydra__f6c3d3c0e1e8ce04deba0ff9b568a9c5.jpg";
    sha256 = "01kcjwfhykj00sj1sbl2gbbs8nw01b2fzlxcbnwq152hdhf8yw7n";
  };

  lgWallpaper = builtins.fetchurl rec {
    name = "${sha256}.jpg";
    url = "https://cdn.donmai.us/original/12/ed/__aston_machan_umamusume_drawn_by_yu_hydra__12ed1215de3805f8b407b3c80b930104.jpg";
    sha256 = "0ji7g9d314r7ns146by35zzfk969106r3i74qqxszdswrvhd4vjc";
  };
in {
  imports = [
    ./themes/rose-pine.nix
    ./hyprland/waybar.nix
    ./hyprland/hypridle.nix
    ./hyprland/hyprlock.nix
  ];

  programs.fuzzel.enable = true;

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
        "${pkgs.vesktop}/bin/vesktop --start-minimized"
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
