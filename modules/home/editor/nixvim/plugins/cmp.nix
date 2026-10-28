# Автодополнение nvim-cmp.
{ ... }: {
  programs.nixvim = {
    # 1. Источники подсказок.
    plugins.cmp-nvim-lsp.enable = true; # подсказки от LSP-сервера
    plugins.cmp-buffer.enable = true;   # слова из текущего файла
    plugins.cmp-path.enable = true;     # пути файловой системы (./folder/)
    plugins.luasnip.enable = true;      # движок сниппетов (обязателен для cmp)

    # 2. Сам движок автодополнения.
    plugins.cmp = {
      enable = true;
      settings = {
        # Раскрытие сниппетов через luasnip.
        snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";

        # Порядок источников определяет их приоритет в меню.
        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "path"; }
          { name = "buffer"; }
        ];

        # Клавиши внутри меню автодополнения.
        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";  # вызвать меню вручную
          "<C-e>" = "cmp.mapping.close()";         # закрыть меню
          "<CR>" = "cmp.mapping.confirm({ select = true })"; # Enter — принять
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";   # вниз по списку
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})"; # вверх по списку
        };
      };
    };
  };
}
