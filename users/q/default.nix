{ ... }:
{
  users.users.q = {
    password = "";
    isNormalUser = true;
  };

  home-manager.users.q = {
    programs.mpv.enable = true;
  };
}
