{ pkgs, ... }:

{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;

    config.pipewire = {
      "context.properties" = {
        "avoid-resampling" = true;
        "default.clock.allowed-rates" = [ 44100 48000 96000 192000 ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    pavucontrol
  ];
}
