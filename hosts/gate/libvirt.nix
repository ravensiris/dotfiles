{pkgs, ...}: {
  systemd.services.libvirtd.preStart = let
    qemuHook = pkgs.writeScript "qemu-hook" ''
      #!${pkgs.stdenv.shell}
      GUEST_NAME="$1"
      OPERATION="$2"
      SUB_OPERATION="$3"
      if [[ "$GUEST_NAME" == "win11"* ]]; then
        if [[ "$OPERATION" == "started" ]]; then
          systemctl set-property --runtime -- system.slice AllowedCPUs=6-10,18-22
          systemctl set-property --runtime -- user.slice AllowedCPUs=6-10,18-22
          systemctl set-property --runtime -- init.scope AllowedCPUs=6-10,18-22
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
    virt-manager
    looking-glass-client
    qemu
    OVMF
    pciutils
    swtpm
    win-virtio
    quickemu
  ];

  boot.kernel.sysctl = {
    "vm.nr_hugepages" = 0;
    "vm.nr_overcommit_hugepages" = 16384;
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  virtualisation.libvirtd.qemu.ovmf.enable = true;
  virtualisation.kvmfr = {
    enable = true;
    shm = {
      enable = true;
      size = 128;
      user = "q";
      group = "libvirtd";
      mode = "0600";
    };
  };
  environment.sessionVariables.LIBVIRT_DEFAULT_URI = ["qemu:///system"];

  virtualisation.libvirtd.qemu.verbatimConfig = ''
    namespaces = []
    cgroup_device_acl = [
        "/dev/null", "/dev/full", "/dev/zero",
        "/dev/random", "/dev/urandom",
        "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
        "/dev/rtc","/dev/hpet", "/dev/vfio/vfio", "/dev/kvmfr0"
    ]
  '';
}
