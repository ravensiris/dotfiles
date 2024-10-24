{...}: {
  networking = {
    useDHCP = false;
    interfaces = {
      br0 = {
        useDHCP = true;
        macAddress = "BA:BE:4D:EC:AD:E5";
      };
      enp5s0.useDHCP = false;
    };
    bridges = {
      "br0" = {
        interfaces = ["enp5s0"];
      };
    };
  };
}
