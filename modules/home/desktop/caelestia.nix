# Caelestia — оболочка рабочего стола на Quickshell (панель, лаунчер, lock,
# уведомления, скриншоты). Модуль подключается в modules/home/default.nix.
{ config, pkgs, vars, ... }: {
  programs.caelestia = {
    enable = true;
    cli.enable = true; # утилита `caelestia` (используется в биндах: emoji, clipboard)
    settings.general.idle = {
      lockbeforesleep = true;   # блокировать экран перед сном
      inhibitwhenaudio = true;  # не считать простоем, пока играет звук
      timeouts = [
        { timeout = vars.idle.lockAfter; idleaction = "lock"; }                 # блокировка
        { timeout = vars.idle.suspendAfter; idleaction = "systemctl suspend"; } # сон (см. примечание в vars.nix)
      ];
    };
  };

  # Окружение, с которым запускается служба Caelestia: чтобы Qt-приложения
  # оболочки находили иконки Papirus/Adwaita и тему GTK.
  # Раньше это делал NixOS (systemd.user.services.caelestia.environment), но
  # такая настройка на системном уровне перекрывалась unit-файлом пользователя
  # из Home Manager; теперь она там же, где сама служба.
  systemd.user.services.caelestia.Service.Environment = [
    "XDG_DATA_DIRS=${pkgs.papirus-icon-theme}/share:${pkgs.adwaita-icon-theme}/share:/etc/profiles/per-user/${config.home.username}/share:${config.home.profileDirectory}/share:/run/current-system/sw/share:${config.home.homeDirectory}/.local/share"
    "QT_QPA_PLATFORMTHEME=gtk2"
  ];

  # Открывать изображения во встроенном просмотрщике Caelestia по умолчанию.
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/jpeg" = [ "caelestia.desktop" ];
      "image/png" = [ "caelestia.desktop" ];
      "image/gif" = [ "caelestia.desktop" ];
      "image/webp" = [ "caelestia.desktop" ];
      "image/bmp" = [ "caelestia.desktop" ];
    };
  };
}
