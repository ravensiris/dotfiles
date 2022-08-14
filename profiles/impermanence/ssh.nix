{ ... }:
{
  services.openssh.hostKeys = {
    {
    path = "/nix/persist/etc/ssh/ssh_host_ed25519_key";
    type = "ed25519";
  },
  {
  path = "/persist/ssh/ssh_host_rsa_key";
  type = "rsa";
  bits = 4096;
}

}
}
