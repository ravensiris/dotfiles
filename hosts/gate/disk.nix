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
            mountpoint = "/boot";
            mountOptions = ["defaults"];
          };
        }
        {
          name = "luks";
          start = "500MiB";
          end = "100%free";
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
        "size=200M"
      ];
    };
  };
};
}
