{ self, ... }:
{
  age.secrets.rootPassword.file = "${self}/secrets/users/root.age";
  users.users.root.passwordFile = "/run/agenix/rootPassword";
}
