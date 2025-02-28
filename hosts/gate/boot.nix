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
  boot.initrd.luks.devices."windows" = {
    device = "/dev/disk/by-uuid/3299548d-f3f7-45f9-8e22-1ebeec3348d9";
  };

  boot.extraModprobeConfig = ''
    options v4l2loopback video_nr=1,10 card_label="OBS","Phone" exclusive_caps=1 max_buffers=2
  '';

  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;
}
