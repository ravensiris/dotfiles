{...}: {
  home.persistence."/nix/persist/home/q".files = [
    ".ssh/id_rsa"
    ".ssh/id_rsa.pub"
    ".ssh/id_ed25519.pub"
    ".ssh/id_ed25519"
    ".ssh/id_rsa_2"
    ".ssh/id_rsa_2.pub"
    ".ssh/config"
  ];
}
