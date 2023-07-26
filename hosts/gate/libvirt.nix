{pkgs, ...}: {
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

  boot.kernelParams = ["amd_iommu=on"];

  boot.extraModprobeConfig = ''
    options vfio-pci ids=0a:00.0,0a:00.1
    options snd_hda_intel power_save=0
  '';
  boot.blacklistedKernelModules = [
    "nvidia"
    "nouveau"
    "nvidia_drm"
    "nvidia_modeset"
    "nvidiafb"
  ];
  systemd.tmpfiles.rules = ["f /dev/shm/looking-glass 0660 root libvirtd -"];
  environment.systemPackages = with pkgs; [
    virtmanager
    looking-glass-client
    qemu
    OVMF
    pciutils
    swtpm
    win-virtio
    quickemu
  ];

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  virtualisation.libvirtd.qemu.ovmf.enable = true;
  environment.sessionVariables.LIBVIRT_DEFAULT_URI = ["qemu:///system"];
}
