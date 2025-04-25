{...}: {
  programs.git = {
    enable = true;
    signing = {
      signByDefault = true;
      key = null;
    };
    userEmail = "maksymilian.jodlowski@gmail.com";
    userName = "Maksymilian Jodłowski";
    extraConfig = {
      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
      };
    };
  };
}
