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
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "amdgpu"];
  # boot.initrd.kernelModules = ["nvme" "dm-snapshot" "i2c-dev" "i2c-piix4" "amdgpu" "vfio" "vfio_iommu_type1" "vfio_pci" "kvm-amd"];
  boot.initrd.kernelModules = ["nvme" "dm-snapshot" "i2c-dev" "i2c-piix4" "amdgpu" "vfio" "vfio_iommu_type1" "vfio_pci" "kvm-amd" "v4l2loopback"];
  boot.extraModulePackages = [
    (pkgs.linuxPackages_latest.v4l2loopback.overrideAttrs (prev: {
      version = "unstable-2024-03-21";
      # https://github.com/umlaeute/v4l2loopback/issues/575
      src = pkgs.fetchFromGitHub {
        owner = "umlaeute";
        repo = "v4l2loopback";
        rev = "cb9e676b46623bfb37f08944a60b1ecb7f20db76";
        hash = "sha256-8a6XL2Hrea+OP85YRsqGTUKrQc5KB8cclpzDJXIm+M0=";
      };
    }))
  ];
  boot.initrd.checkJournalingFS = false;
  boot.initrd.luks.devices."cryptroot".preLVM = true;
  boot.initrd.luks.devices."windows" = {
    device = "/dev/disk/by-uuid/3299548d-f3f7-45f9-8e22-1ebeec3348d9";
  };

  services.xserver.videoDrivers = ["amdgpu"];

  hardware.enableRedistributableFirmware = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
}
