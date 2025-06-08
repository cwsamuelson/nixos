{ pkgs, ... }: {
  #! @TODO setup config
  programs.tmux = {
    enable = true;

    clock24 = true;
    # on qwerty or standard dvorak, 1 is more convenient than 0
    baseIndex = 1;
    focusEvents = true;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    #plugins = [
    #];
    # good one to override based on what shell is chosen
    # might mean changing it in the <shell>.nix modules
    #shell = "...";
  };
}
