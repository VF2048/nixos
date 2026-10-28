# Stylix — единая цветовая схема, строящаяся по обоям.
#
# ВАЖНО: в исходной конфигурации `stylix.enable` нигде не был выставлен, то есть
# Stylix фактически не работал, а все настройки ниже были «мёртвыми». Чтобы не
# менять поведение, по умолчанию он остаётся выключен (vars.features.stylix =
# false). Включите флаг — и Stylix применит палитру ко всем поддерживаемым
# программам. Курсор/шрифты в этом случае согласованы с остальными модулями,
# т.к. все значения берутся из vars.nix.
{ pkgs, vars, ... }: {
  stylix = {
    enable = vars.features.stylix;
    image = vars.paths.wallpaper;      # палитра строится по этому изображению
    polarity = vars.theme.polarity;    # тёмная или светлая схема
    opacity = vars.theme.opacity;      # прозрачность терминала и приложений

    cursor = {
      package = pkgs.bibata-cursors;
      name = vars.theme.cursor.name;
      size = vars.theme.cursor.size;
    };

    fonts = {
      monospace = { package = pkgs.nerd-fonts.jetbrains-mono; name = vars.theme.fonts.monospace; };
      sansSerif = { package = pkgs.montserrat; name = vars.theme.fonts.sansSerif; };
      serif = { package = pkgs.montserrat; name = vars.theme.fonts.serif; };
      sizes = vars.theme.fonts.sizes;
    };

    targets = {
      # Эти программы Stylix НЕ красит: у них собственные темы/оболочка.
      waybar.enable = false;     # тема waybar задана вручную (desktop/waybar.nix)
      hyprland.enable = false;   # цвета рамок Hyprland — свои
      hyprlock.enable = false;   # hyprlock оформляется вручную
      # Прозрачный фон Neovim (поверх обоев/блюра терминала).
      nixvim.transparentBackground.main = true;
    };
  };
}
