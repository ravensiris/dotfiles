{
  root,
  dropOverrides,
  ...
}: {
  disko.devices =
    dropOverrides (root.partitioning.encryptedLVMWithTmpfsRoot.override
      {disks = ["/dev/vda"];});
}
