{
  lib,
  disks ? ["/dev/vda"],
  ...
}: {
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
            mountpoint = "/boot";
            mountOptions = ["default"];
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
    pool = {
      type = "lvm_vg";
      lvs = {
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
            mountOptions = ["defaults"];
          };
        };
      };
    };
  };
}