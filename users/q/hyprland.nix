{
  pkgs,
  hyprland,
  lib,
  ...
}: {
  imports = [./themes/tokyo-night.nix];

  programs.fuzzel.enable = true;

  programs.eww = {
    enable = true;
    configDir = ./hyprland/eww;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "${pkgs.unstable.kitty}/bin/kitty";
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
