{...}:
{
  users.users.q = {
    password = "arstarst";
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "docker" "adbusers" "input" ];
  };
}
