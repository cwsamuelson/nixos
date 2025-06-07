{ pkgs, ... }: {
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;

    #plugins = {};
    #flavors = {};# preferred over themes
    #theme = {};
    #keymap = {};

    settings = {
      manager = {
        sort_sensitive = false;
        sort_dir_first = true;
        show_hidden = true;
        show_symlink = true;
        scrolloff = 8;
      };

      preview = {
        wrap = "no";
        tab_size = 2;
      };

      opener = {
        tab_test = [
          {
            run = "kitten @ launch --type=tab $EDITOR $@";
            #run = ''
            #  kitten @ launch --type=tab --tab-title $(basename $@) ''${EDITOR:-nvim} $@
            #'';
            #run = "kitten @ launch --type=tab --tab-title ''\"$@''\" echo $@";
            #run = "firefox $@";
            desc = "Open editor in new Kitty tab";
            #orphan = true;
          }
        ];
      };

      open = {
        prepend_rules = [
          {
            name = "*.cc";
            use = "tab_test";
          }
        ];
      };
    };
  };
}
