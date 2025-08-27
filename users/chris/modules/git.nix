{ pkgs, user, ... }: {
  programs.git = {
    enable = true;

    userName = user.name;
    userEmail = "chris.sam55@gmail.com";

    lfs.enable = true;

    aliases = {
      root = "rev-parse --show-toplevel";
      st = "status";
      co = "checkout";
      uncommit = "reset --soft HEAD^";
      discard = "reset HEAD --hard";

      # this <action>-<intent> style makes commands organized discoverable by tab-complete

      log-graph = "log --graph --abbrev-commit --date=relative --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset'";

      diff-all = "!\"for name in $(git diff --name-only $1); do git difftool -y $1 $name & done\"";
      diff-changed = "diff --name-status -r";
      diff-stat = "diff --stat --ignore-space-change -r";
      diff-staged = "diff --cached";
      diff-upstream = "!git fetch origin && git diff main origin/main";
      diff-words = "diff --color-words='[^[:space:]]|([[:alnum:]]|UTF_8_GUARD)+'";
    };

    difftastic = {
      enable = true;
      background = "dark";
      color = "auto";
      display = "side-by-side";
    };
 
    ignores = [];
 
    extraConfig = {
      init.defaultBranch = "main";

      grep.lineNumber = "true";
      grep.fullName = "true";
    };
  };

  home.packages = with pkgs; [
    tig
  ];
}
