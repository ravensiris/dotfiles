{
  lib,
  pkgs,
  devenv,
  ...
}: {
  imports = [
    (import ./disk.nix {
      inherit lib;
      disks = ["/dev/nvme0n1"];
    })
    ./boot.nix
    ./persistence.nix
    ./users.nix
  ];

  sound.enable = true;

  boot.kernelPatches = [
    {
      name = "quirk-x570-ultra-reaktek";
      patch = ./0001-Add-realtek-quirk-fix-for-X570-Aorus-Ultra.patch;
    }
  ];

  time.timeZone = "Europe/Warsaw";

  virtualisation.docker.enable = true;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gnome3";
    enableSSHSupport = true;
  };

  networking = {
    useDHCP = false;
    interfaces = {
      br0 = {
        useDHCP = true;
        macAddress = "BA:BE:4D:EC:AD:E5";
      };
      enp5s0.useDHCP = true;
    };
    bridges = {
      "br0" = {
        interfaces = ["enp5s0"];
      };
    };
  };

  systemd.services.libvirtd.preStart = let
    qemuHook = pkgs.writeScript "qemu-hook" ''
      #!${pkgs.stdenv.shell}
      GUEST_NAME="$1"
      OPERATION="$2"
      SUB_OPERATION="$3"
      if [[ "$GUEST_NAME" == "win11"* ]]; then
        if [[ "$OPERATION" == "started" ]]; then
          systemctl set-property --runtime -- system.slice AllowedCPUs=11,23
          systemctl set-property --runtime -- user.slice AllowedCPUs=11,23
          systemctl set-property --runtime -- init.scope AllowedCPUs=11,23
        fi
        if [[ "$OPERATION" == "stopped" ]]; then
          systemctl set-property --runtime -- user.slice AllowedCPUs=0-23
          systemctl set-property --runtime -- system.slice AllowedCPUs=0-23
          systemctl set-property --runtime -- init.scope AllowedCPUs=0-23
        fi
      fi
    '';
  in ''
    mkdir -p /var/lib/libvirt/hooks
    chmod 755 /var/lib/libvirt/hooks
    # Copy hook files
    ln -sf ${qemuHook} /var/lib/libvirt/hooks/qemu
  '';

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs;
    [
      pavucontrol
      docker-compose
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
    ]
    ++ [devenv.packages.x86_64-linux.devenv];

  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "2";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };

  programs.fish.enable = true;
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

  home-manager.users.q = {
    wayland.windowManager.sway = {
      enable = true;
      extraConfig = ''
        input * xkb_layout pl
      '';
      config = rec {
        modifier = "Mod4";
        # Use kitty as default terminal
        terminal = "${pkgs.kitty}/bin/kitty";
        menu = "${pkgs.fuzzel}/bin/fuzzel --show-actions";
        startup = [
          {
            command = "XDG_CONFIG_HOME=/home/q/.config ${pkgs.swaynotificationcenter}/bin/swaync";
            always = true;
          }
        ];
        keybindings = lib.mkOptionDefault {
          # Focus window
          "${modifier}+n" = "focus left";
          "${modifier}+e" = "focus down";
          "${modifier}+i" = "focus up";
          "${modifier}+o" = "focus right";
          # Move window
          "${modifier}+Shift+n" = "move left";
          "${modifier}+Shift+e" = "move down";
          "${modifier}+Shift+i" = "move up";
          "${modifier}+Shift+o" = "move right";
          # Workspaces
          "${modifier}+0" = "workspace number 10";
          "${modifier}+Shift+0" = "move container to workspace number 10";
          # Mode
          "${modifier}+u" = "layout default";
          "${modifier}+v" = "splitv";
          "${modifier}+h" = "splith";

          "${modifier}+y" = "exec ${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";

          # Quick launch
          "${modifier}+m" = "exec emacsclient -c";

          "${modifier}+s" = "layout default";
          "${modifier}+w" = "layout default";

          "${modifier}+p" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp -d)\" - | ${pkgs.wl-clipboard}/bin/wl-copy";
        };
        modes = {
          resize = {
            # colemak
            n = "resize shrink width 50px";
            e = "resize grow height 50px";
            i = "resize shrink height 50px";
            o = "resize grow width 50px";
            # arrows
            Left = "resize shrink width 50px";
            Up = "resize grow height 50px";
            Down = "resize shrink height 50px";
            Right = "resize grow width 50px";
            # Set %
            Equal = "resize set height 50ppt";
            "1" = "resize set height 10ppt";
            "2" = "resize set height 20ppt";
            "3" = "resize set height 30ppt";
            "4" = "resize set height 40ppt";
            "5" = "resize set height 50ppt";
            "6" = "resize set height 60ppt";
            "7" = "resize set height 70ppt";
            "8" = "resize set height 80ppt";
            "9" = "resize set height 90ppt";
            Escape = "mode default";
          };
        };
        fonts = {
          names = ["VictorMono Nerd Font"];
          style = "Regular";
          size = 18.0;
        };
        bars = [
          (lib.mkOptionDefault {
            position = "top";
            # statusCommand =
            # "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
            fonts = {
              names = ["VictorMono Nerd Font"];
              size = 12.0;
            };
          })
        ];
      };
    };
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

  fonts.fonts = with pkgs; [
    migu
    baekmuk-ttf
    nanum
    noto-fonts-emoji
    twemoji-color-font
    openmoji-color
    twitter-color-emoji
    nerdfonts
  ];
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "sway"; # https://github.com/emersion/xdg-desktop-portal-wlr/issues/20
    XDG_SESSION_TYPE = "wayland"; # https://github.com/emersion/xdg-desktop-portal-wlr/pull/11
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.substituters = ["https://nix-community.cachix.org" "https://cache.nixos.org"];
  nix.settings.trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
  networking.hostName = "gate";
  system.stateVersion = "23.05";
}
