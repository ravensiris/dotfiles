{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    qmk
  ];

  services.udev.packages = with pkgs; [qmk-udev-rules];
}
