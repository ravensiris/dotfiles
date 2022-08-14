{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    virtmanager
    qemu
    OVMF
    pciutils
    swtpm
    win-virtio
  ];

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  virtualisation.libvirtd.qemu.ovmf.enable = true;
  environment.sessionVariables.LIBVIRT_DEFAULT_URI = [ "qemu:///system" ];
  # virtualisation.libvirtd.qemu.verbatimConfig = ''
  #   nvram = [
  #     "${pkgs.OVMF}/FV/OVMF.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd"
  #   ]
  #   namespaces = []
  #   user = "+1000"
  # '';
}
