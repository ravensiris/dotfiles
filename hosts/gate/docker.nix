{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    docker-compose
  ];
  virtualisation.docker.enable = false;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
}
