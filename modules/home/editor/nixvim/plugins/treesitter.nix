# Treesitter — подсветка синтаксиса, отступы и складки по дереву разбора.
{ pkgs, ... }: {
  programs.nixvim.plugins.treesitter = {
    enable = true;
    nixvimInjections = true; # подсветка Lua/Vim внутри строк Nix-конфигурации
    folding.enable = true;   # складки по синтаксическому дереву
    # Только перечисленные грамматики (собираются Nix, а не качаются на лету).
    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      nix bash markdown json cpp javascript cmake
    ];
    settings = {
      auto_install = false;     # не скачивать грамматики автоматически
      highlight.enable = true;  # подсветка
      indent.enable = true;     # авто-отступы
    };
  };
}
