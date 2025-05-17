{...}: {
  services.ollama = {
    enable = true;
    loadModels = ["qwen3:14b" "deepseek-r1:14b" "gemma3:12b" "gemma3:27b"];
  };

  services.open-webui = {
    enable = true;
    port = 6183;
  };

  environment.persistence."/nix/persist" = {
    directories = [
      "/var/lib/private/open-webui"
      "/var/lib/private/ollama"
    ];
  };
}
