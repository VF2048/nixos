# Горячие клавиши режима Normal. (Клавиши F5–F7 для CMake — в plugins/cmake-tools.nix.)
# <leader> по умолчанию — это "\" (если не переопределён в globals.mapleader).
{ lib, ... }: {
  programs.nixvim.keymaps =
    let
      # Таблица «клавиши → действие»; превращается в список keymaps в режиме "n".
      normal = {
        # --- Oil (файловый менеджер) ---
        "<C-Backspace>" = ":Oil .<CR>";  # открыть Oil в текущем рабочем каталоге
        "<Backspace>" = ":Oil<CR>";      # открыть Oil в каталоге текущего файла

        # --- Файл ---
        "<C-s>" = ":w<CR>";              # сохранить файл

        # --- Telescope: поиск ---
        "<leader>ff" = ":Telescope find_files<CR>";   # поиск файлов
        "<leader>fl" = ":Telescope live_grep<CR>";    # поиск по содержимому
        "<leader>fb" = ":Telescope buffers<CR>";      # список буферов
        "<leader>fd" = ":Telescope diagnostics<CR>";  # диагностика LSP
        "<leader>cd" = ":cd<CR>:te<CR>:f term_root<CR>"; # перейти в $HOME и открыть терминал "term_root"

        # --- LSP ---
        "<leader>do" = "<cmd>lua vim.diagnostic.open_float()<CR>"; # показать диагностику под курсором

        # --- CMake ---
        "<leader>cg" = "<cmd>CMakeGenerate<CR>";       # сгенерировать файлы сборки (один раз)
        "<leader>cb" = "<cmd>CMakeBuild<CR>";          # собрать проект (основная команда)
        "<leader>cr" = "<cmd>CMakeRun<CR>";            # запустить бинарник
        "<leader>cc" = "<cmd>CMakeRunCurrentFile<CR>"; # запустить текущий файл
      };
    in
    lib.mapAttrsToList (key: action: {
      mode = "n";
      inherit action key;
    }) normal;
}
