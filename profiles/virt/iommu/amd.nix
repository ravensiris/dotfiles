{ ... }:

{
  imports = [ ./common.nix ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelParams = [ "amd_iommu=on" ];
}
