{
  config,
  lib,
  pkgs,
  inputs,
  user,
  ...
}: {
  users.users.${user} = {
    isNormalUser = true;
  };
}
