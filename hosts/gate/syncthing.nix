{...}: {
  services.syncthing = {
    enable = true;
    dataDir = "/home/q/Sync";
    configDir = "/home/q/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    user = "q";
    devices = {
      "phone" = {id = "DI26IOA-H4YSNID-JDPFEMG-5UVY4WV-BDFGG2S-HKJFVD6-7ACZ5NH-BTD6DQ7";};
    };
    folders = {
      "Music" = {
        path = "/home/q/Music";
        devices = ["phone"];
        type = "sendonly";
      };
    };
  };
}
