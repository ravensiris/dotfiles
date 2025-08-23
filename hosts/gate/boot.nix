{pkgs, ...}: {
  boot.loader = {
    efi = {
      efiSysMountPoint = "/boot";
      canTouchEfiVariables = true;
    };
    systemd-boot = {
      enable = true;
      configurationLimit = 20;
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = ["nvme" "dm-snapshot" "i2c-dev" "i2c-piix4" "vfio" "vfio_iommu_type1" "vfio_pci" "kvm-amd" "v4l2loopback"];
  boot.extraModulePackages = with pkgs; [
    linuxPackages_latest.v4l2loopback
    linuxPackages_latest.kvmfr
  ];
  boot.initrd.checkJournalingFS = false;
  boot.initrd.luks.devices."cryptroot".preLVM = true;

  # sudo filefrag -v /nix/persist/swapfile | awk '$1=="0:" {print substr($4, 1, length($4)-2)}'
  boot.kernelParams = ["resume_offset=31205376"];
  # sudo findmnt -no UUID -T /nix/persist/swapfile
  boot.resumeDevice = "/dev/disk/by-uuid/5560c4e3-4f9d-40d3-b7fc-a4fc3f13f74b";
  powerManagement.enable = true;

  boot.extraModprobeConfig = ''
    options v4l2loopback video_nr=1,10 card_label="OBS","Phone" exclusive_caps=1 max_buffers=2
  '';

  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;
}
