{
  lib,
  pkgs,
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

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
    enableSSHSupport = true;
  };

  systemd.services.libvirtd.preStart =
    let
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
    in
    ''
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

  environment.systemPackages = with pkgs; [
    pavucontrol
  ];

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      fira
      source-code-pro
      source-sans-pro
      source-serif-pro
    ];
    fontconfig = {
      antialias = true;
      cache32Bit = true;
      hinting.enable = true;
      hinting.autohint = true;
      defaultFonts = {
        monospace = ["Source Code Pro"];
        sansSerif = ["Source Sans Pro"];
        serif = ["Source Serif Pro"];
      };
    };
  };

  programs.fish.enable = true;
  programs.sway = {
    enable = true;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  networking.hostName = "gate";
  system.stateVersion = "23.05";
}
