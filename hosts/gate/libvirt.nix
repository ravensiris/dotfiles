{
  pkgs,
  config,
  ...
}: let
  alloc_hugepages = pkgs.writeScriptBin "alloc_hugepages" ''
    #!${pkgs.bash}/bin/bash

    ## Calculate number of hugepages to allocate from memory (in MB)
    HUGEPAGES="$(($MEMORY/$(($(grep Hugepagesize /proc/meminfo | ${pkgs.gawk}/bin/awk '{print $2}')/1024))))"

    echo "Allocating hugepages..." > /dev/kmsg
    echo $HUGEPAGES > /proc/sys/vm/nr_hugepages
    ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)

    TRIES=0
    while (( $ALLOC_PAGES != $HUGEPAGES && $TRIES < 1000 ))
    do
        echo 1 > /proc/sys/vm/compact_memory            ## defrag ram
        echo $HUGEPAGES > /proc/sys/vm/nr_hugepages
        ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)
        echo "Succesfully allocated $ALLOC_PAGES / $HUGEPAGES"  > /dev/kmsg
        let TRIES+=1
    done

    if [ "$ALLOC_PAGES" -ne "$HUGEPAGES" ]
    then
        echo "Not able to allocate all hugepages. Reverting..."  > /dev/kmsg
        echo 0 > /proc/sys/vm/nr_hugepages
        exit 1
    fi
  '';

  dealloc_hugepages = pkgs.writeScriptBin "dealloc_hugepages" ''
    #!${pkgs.bash}/bin/bash

    echo "Deallocating hugepages"  > /dev/kmsg
    echo 0 > /proc/sys/vm/nr_hugepages
  '';
in {
  systemd.services.libvirtd.preStart = let
    qemuHook = pkgs.writeScript "qemu-hook" ''
      #!${pkgs.bash}/bin/bash

      GUEST_NAME="$1"
      OPERATION="$2"
      SUB_OPERATION="$3"

      if [[ "$GUEST_NAME" == "win11"* ]]; then
        if [[ "$OPERATION" == "prepare" ]]; then
          export MEMORY=32768

          ${alloc_hugepages}/bin/alloc_hugepages
        fi
        if [[ "$OPERATION" == "started" ]]; then
          systemctl set-property --runtime -- system.slice AllowedCPUs=8,20,9,21
          systemctl set-property --runtime -- user.slice AllowedCPUs=8,20,9,21
          systemctl set-property --runtime -- init.scope AllowedCPUs=8,20,9,21
        fi
        if [[ "$OPERATION" == "stopped" ]]; then
          systemctl set-property --runtime -- user.slice AllowedCPUs=0-23
          systemctl set-property --runtime -- system.slice AllowedCPUs=0-23
          systemctl set-property --runtime -- init.scope AllowedCPUs=0-23
          ${dealloc_hugepages}/bin/dealloc_hugepages
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
    pciutils
    swtpm
    win-virtio
    quickemu
    alloc_hugepages
    dealloc_hugepages
  ];

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  virtualisation.libvirtd.qemu.ovmf = {
    enable = true;
    packages = [pkgs.OVMFFull.fd];
  };

  environment.etc = {
    "ovmf/edk2-x86_64-secure-code.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-x86_64-secure-code.fd";
    };

    "ovmf/edk2-i386-vars.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-i386-vars.fd";
    };
  };

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
