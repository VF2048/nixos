# Иконки для GTK и Qt. Раньше этот блок был встроен в hosts/main/home-manager.nix.
{ pkgs, lib, vars, ... }: {
  gtk = {
    enable = true;
    # Тёмная тема GTK (раньше её выставлял Stylix).
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    # Приложения на GTK3/GTK4 без libadwaita смотрят на этот флаг.
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
    iconTheme = {
      name = vars.theme.iconThemeGtk; # "Papirus-Dark"
      package = pkgs.papirus-icon-theme;
    };
  };

  # Сигнал «предпочитаю тёмную схему» для libadwaita, Flutter, Firefox и др.
  # (читается через org.freedesktop.appearance / xdg-desktop-portal).
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-theme = "adw-gtk3-dark";
  };

  # Конфигурация qt6ct (инструмент выбора темы для Qt6-приложений).
  # mkForce нужен, чтобы перекрыть файл, который мог бы создать другой модуль
  # (например, Stylix при включении), и оставить только эту настройку.
  xdg.configFile."qt6ct/qt6ct.conf".source =
    lib.mkForce ((pkgs.formats.ini { }).generate "qt6ct-config" {
      Appearance.icon_theme = vars.theme.iconThemeQt; # "Papirus"
    });
}
