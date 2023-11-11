{...}: {
  services.syncthing = {
    enable = true;
    user = "q";
    dataDir = "/home/q/Documents";
    configDir = "/home/q/Documents/.config/syncthing";
  };
}
