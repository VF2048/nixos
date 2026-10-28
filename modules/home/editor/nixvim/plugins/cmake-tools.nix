# Интеграция CMake (cmake-tools.nvim) + функциональные клавиши.
{ ... }: {
  programs.nixvim = {
    keymaps = [
      { mode = "n"; key = "<F7>"; action = "<cmd>CMakeBuild<CR>"; options = { silent = true; desc = "CMake Build Project"; }; } # собрать
      { mode = "n"; key = "<F6>"; action = "<cmd>CMakeStopRunner<CR>"; options = { silent = true; desc = "CMake Stop Target"; }; } # остановить запущенную цель
      { mode = "n"; key = "<F5>"; action = "<cmd>CMakeRun<CR>"; options = { silent = true; desc = "CMake Run Target"; }; } # запустить
    ];

    plugins.cmake-tools = {
      enable = true;
      settings = {
        # Пустой блок: плагин наследует переменные окружения терминала, поэтому
        # пути из nix-direnv автоматически попадают в cmake.
        cmake_environ = { };
        # Запускать цели во встроенном терминале...
        cmake_runner.name = "terminal";
        # ...а вывод сборки направлять в quickfix-список.
        cmake_executor.name = "quickfix";
      };
    };
  };
}
