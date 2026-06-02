{
  programs.nixvim = {
    plugins.telescope = {
      enable = true;

      settings = { 
        defaults = {
          file_ignore_patterns = [
            "^.git/"
            "^.secret/"
            "^.env"
            "^.envrc"
          ];
          #layout_strategy = "vertical";
          #sorting_strategy = "ascending";
                    #border = false;
                    #hidden = true;
                    #layout_config = {
                    #            prompt_position = "top";
                    # height = 0.999;
                    #   width = 0.999;
                    #};
                    #      set_env.COLORTERM = "truecolor";
          mappings = {
            i = {
              "<C-v>".__raw = "function() vim.cmd 'normal! p' vim.cmd 'startinsert!' end";
              "<C-Backspace>".__raw = "function() vim.cmd 'normal! bdw' vim.cmd 'startinsert!' end";
            };
          };
        };

        pickers = {
          find_files.hidden = true;
          live_grep.hidden = true;
        };
      };

      extensions = {
        fzf-native.enable = true;
      };
    };
  };
}
