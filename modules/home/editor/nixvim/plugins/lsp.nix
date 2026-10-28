# Языковые серверы (LSP).
{ ... }: {
  programs.nixvim.plugins.lsp = {
    enable = true;

    # Клавиши, работающие в буфере с активным LSP.
    keymaps.lspBuf = {
      "gd" = "definition";        # перейти к определению
      "gr" = "references";        # найти использования
      # "gt" = "type_definition"; # перейти к определению типа
      "gi" = "implementation";    # перейти к реализации
      "<leader>a" = "code_action";# действия кода (быстрые исправления)
      "<leader>r" = "rename";     # переименовать символ
      # "<leader>i" = "incoming_calls";   (отключено: занято hover)
      # "<leader>o" = "outgoing_calls";
      "<leader>i" = "hover";      # документация под курсором
    };

    servers = {
      # Nix.
      nixd = {
        enable = true;
        # ВНИМАНИЕ: `import <nixpkgs> {}` требует канала <nixpkgs>, которого
        # на flake-системе может не быть; для точного автодополнения лучше
        # указать flake напрямую через builtins.getFlake.
        settings.nixpkgs.expr = "import <nixpkgs> {}";
      };
      clangd.enable = true; # C/C++
      rust_analyzer = {
        enable = true;
        # Cargo и rustc берутся из окружения проекта (nix-direnv), а не ставятся с сервером.
        installCargo = false;
        installRustc = false;
        settings.cargo = {
          features = "all";                  # собирать со всеми feature-флагами
          targetDir = "target_rust_analyzer"; # отдельный target-каталог — не мешает обычной сборке
        };
      };
      wgsl_analyzer.enable = true; # шейдеры WGSL
      # java_language_server.enable = true;
      # cmake.enable = true;
      # lua_ls.enable = true;
    };
  };
}
