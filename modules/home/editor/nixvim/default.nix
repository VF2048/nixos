# Neovim через Nixvim. Раньше был NixOS-модулем, теперь — модуль Home Manager
# (сам модуль nixvim подключается в modules/home/default.nix).
{ pkgs, ... }: {
  imports = [
    ./options.nix   # опции редактора и глобальные переменные
    ./keymaps.nix   # горячие клавиши
    ./plugins       # плагины
  ];

  programs.nixvim = {
    enable = true;
    viAlias = true;        # команда `vi` запускает nvim
    vimAlias = true;       # команда `vim` запускает nvim
    defaultEditor = true;  # EDITOR=nvim для git, sudoedit и т.д.
    # Брать nixpkgs для сборки плагинов из той же ревизии, что и система.
    nixpkgs.source = pkgs.path;

    # Цветовая схема catppuccin.
    # ВНИМАНИЕ: в options.nix включена ещё и onedark — две схемы включены
    # одновременно. Оставьте одну, чтобы поведение было предсказуемым.
    colorschemes.catppuccin.enable = true;

    plugins = {
      lualine.enable = true; # строка состояния
      oil.enable = true;     # файловый менеджер как обычный буфер (клавиши — в keymaps.nix)
    };
  };
}
