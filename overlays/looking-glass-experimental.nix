final: prev: {
  looking-glass-client = prev.looking-glass-client.overrideAttrs (o: rec {
    version = "B6";
    src = prev.fetchFromGitHub {
      rev = version;
      sha256 = "";
    };
  });
}
