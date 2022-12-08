{ ... }:
{
  boot.blacklistedKernelModules = [
    "nvidia"
    "nouveau"
    "nvidia_drm"
    "nvidia_modeset"
    "nvidiafb"
  ];
}
