# Курсор мыши. Имя и размер — в vars.nix → theme.cursor.
{ pkgs, vars, ... }: {
  home.pointerCursor = {
    package = pkgs.bibata-cursors; # пакет с темой курсора (устанавливается тоже)
    name = vars.theme.cursor.name;
    size = vars.theme.cursor.size;
    gtk.enable = true; # применить к GTK-приложениям
    x11.enable = true; # применить к X11/XWayland-приложениям
  };
}
