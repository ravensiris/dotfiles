{...}: {
  services.syncthing = {
    enable = true;
    user = "q";
    dataDir = "/home/q/Documents";
    configDir = "/home/q/Documents/.config/syncthing";
  };

  networking.firewall = {
    allowedTCPPorts = [22000];
    allowedUDPPorts = [22000 21027];
  };
}
