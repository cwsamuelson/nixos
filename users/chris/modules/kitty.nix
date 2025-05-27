{ pkgs, config, ... }: {
  programs.kitty = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.kitty;
    shellIntegration = {
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    font = {
      name = "DejaVuSansMono";
      size = 18;
    };

    settings = {
      allow_remote_control = true;
    };
  };
}
