# Плагины Nixvim: общий список подмодулей и небольшие плагины без отдельной настройки.
{
  imports = [
    ./treesitter.nix   # подсветка и структура кода
    ./telescope.nix    # нечёткий поиск
    ./lsp.nix          # языковые серверы
    ./cmake-tools.nix  # интеграция CMake
    ./cmp.nix          # автодополнение
    ./which-key.nix    # подсказки по клавишам
  ];

  programs.nixvim.plugins = {
    web-devicons.enable = true; # файловые иконки для Telescope/Oil/lualine
    mini = {
      enable = true;
      modules = {
        icons = { }; # mini.icons с настройками по умолчанию
      };
    };
  };
}
