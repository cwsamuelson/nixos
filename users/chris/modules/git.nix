{ pkgs, user, ... }: {
  programs.git = {
    enable = true;

    userName = user.name;
    userEmail = "chris.sam55@gmail.com";

    aliases = {
      st = "status";
      co = "checkout";
      uncommit = "reset --soft HEAD^";
      discard = "reset HEAD --hard";
      graph = "git log --graph --oneline --all";

      # this diff-intent style makes commands discoverable by autocomplete, and more organized
      # <command>-<intent>
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
}
