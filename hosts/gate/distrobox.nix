{pkgs, ...}: {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };

  environment.persistence."/nix/persist".users.q.directories = [
    ".local/share/containers"
  ];

  environment.systemPackages = [pkgs.distrobox];
}
