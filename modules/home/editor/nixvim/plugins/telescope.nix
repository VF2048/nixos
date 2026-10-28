# Telescope — нечёткий поиск файлов/текста. Клавиши — в keymaps.nix.
{ ... }: {
  programs.nixvim.plugins.telescope = {
    enable = true;

    settings = {
      defaults = {
        # Исключения из поиска (регулярные выражения). Скрытые файлы при этом
        # ищутся (см. pickers), но служебные и секретные — нет.
        file_ignore_patterns = [
          "^.git/"
          "^.secret/"
          "^.env"
          "^.envrc"
        ];
        mappings.i = {
          # Ctrl+V в строке поиска вставляет текст из регистра.
          "<C-v>".__raw = "function() vim.cmd 'normal! p' vim.cmd 'startinsert!' end";
          # Ctrl+Backspace удаляет слово.
          "<C-Backspace>".__raw = "function() vim.cmd 'normal! bdw' vim.cmd 'startinsert!' end";
        };
      };

      # Искать и среди скрытых файлов.
      pickers = {
        find_files.hidden = true;
        live_grep.hidden = true;
      };
    };

    # fzf-native: быстрая сортировка результатов.
    extensions.fzf-native.enable = true;
  };
}
