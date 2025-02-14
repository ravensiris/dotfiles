{
  pkgs,
  config,
  ...
}: {
  users.users."q".extraGroups = ["adbusers"];

  programs.adb.enable = true;

  home.packages = with pkgs; [android-studio];

  home.sessionVariables = {
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
    ADB_VENDOR_KEY = "${config.xdg.configHome}/android";
    ANDROID_USER_HOME = "${config.xdg.dataHome}/android";
    ANDROID_AVD_HOME = "${config.xdg.dataHome}/android/avd";
  };

  home.persistence."/nix/persist/home/q".directories = [
    ".cache/Google"
    ".config/Google"
    ".local/share/Google"

    ".config/java"
    ".gradle"

    ".config/android"
    ".local/share/android"
  ];
}
