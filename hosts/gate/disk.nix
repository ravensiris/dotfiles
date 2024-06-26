{
  lib,
  disks ? ["/dev/vda"],
  ...
}: {
  disko.devices = {
    disk = lib.genAttrs disks (dev: {
      type = "disk";
      device = dev;
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            label = "ESP";
            size = "500M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "defaults"
              ];
            };
          };
          luks = {
            label = "luks";
            size = "100%";
            content = {
              type = "luks";
              name = "cryptroot";
              extraOpenArgs = [];
              settings = {
                allowDiscards = true;
              };
              keyFile = "/tmp/secret.key";
              content = {
                type = "lvm_pv";
                vg = "pool";
              };
            };
          };
        };
      };
    });

    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/nix";
              mountOptions = ["defaults"];
            };
          };
        };
      };
    };

    nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = [
          "defaults"
          "size=8G"
          "mode=755"
        ];
      };
      "/tmp" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=8G"
        ];
      };
    };
  };
}
