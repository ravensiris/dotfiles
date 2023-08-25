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
        type = "table";
        format = "gpt";
        partitions = [
          {
            name = "ESP";
            start = "1MiB";
            end = "500MiB";
            bootable = true;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot/EFI";
              mountOptions = ["defaults"];
            };
          }
          {
            name = "luks";
            start = "500MiB";
            end = "100%";
            content = {
              type = "luks";
              name = "cryptroot";
              extraOpenArgs = ["--allow-discards"];
              keyFile = "/tmp/secret.key";
              content = {
                type = "lvm_pv";
                vg = "pool";
              };
            };
          }
        ];
      };
    });
    lvm_vg = {
      vg_root = {
        type = "lvm_vg";
        lvs = {
          lv_nixos = {
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
          "size=4G"
          "mode=755"
        ];
      };
      "/tmp" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=4G"
        ];
      };
    };
  };
}
