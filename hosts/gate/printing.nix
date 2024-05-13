{pkgs, ...}: {
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    pkgs.hplip
    pkgs.gutenprint
  ];
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };
}
