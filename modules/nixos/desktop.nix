# Рабочий стол на системном уровне.
# Конфигурация самого Hyprland — в Home Manager (modules/home/desktop/hyprland).
# Здесь остаётся лишь то, что требует root: регистрация сессии, порталы,
# системные службы и политика питания.
{ pkgs, ... }: {
  # --- Hyprland: системная часть ------------------------------------------
  # programs.hyprland.enable создаёт запись сессии для менеджера входа,
  # ставит XDG-портал Hyprland и настраивает UWSM. Без него одной настройки
  # в Home Manager недостаточно.
  programs.hyprland = {
    enable = true;
    xwayland.enable = true; # запуск X11-приложений
    withUWSM = true;        # запуск сессии под управлением systemd (UWSM)
  };

  # dconf нужен, чтобы Home Manager мог записывать настройки (dconf.settings),
  # в том числе color-scheme = prefer-dark, которую читают GTK/Flutter-приложения.
  programs.dconf.enable = true;

  # --- Порталы (XDG Desktop Portal): диалоги выбора файлов, скриншоты, ----
  # --- демонстрация экрана. Работают как системные службы.
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland # скриншоты и screencast в Hyprland
      pkgs.xdg-desktop-portal-gtk      # диалоги GTK (раньше задавался в Home Manager)
    ];
    # "*" — для каждого интерфейса порталы выбираются автоматически.
    config.common.default = "*";
  };

  # --- Системные службы ----------------------------------------------------
  # X11-сервер нужен драйверу NVIDIA и XWayland-приложениям.
  services.xserver.enable = true;
  services.upower.enable = true;                # данные о батарее и питании
  services.power-profiles-daemon.enable = true; # профили производительности
  services.printing.enable = true;              # CUPS: печать документов
  services.openssh.enable = true;               # SSH-сервер
  services.blueman.enable = true;               # менеджер bluetooth (GUI)

  # --- Политика питания ----------------------------------------------------
  # Разрешаем systemd управлять обычным сном, гибридным сном и гибернацией.
  systemd.targets.sleep.enable = true;
  systemd.targets.suspend.enable = true;
  systemd.targets.hybrid-sleep.enable = true;
  systemd.targets.hibernate.enable = true;
}
