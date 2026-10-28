# which-key — всплывающая подсказка по доступным сочетаниям клавиш.
{ ... }: {
  programs.nixvim.plugins.which-key = {
    enable = true;
    settings.icons = {
      mappings = true; # показывать иконки у клавиш
      rules = [ ];     # собственные правила иконок не заданы
    };
  };
}
