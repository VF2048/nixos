# Экран входа: greetd + tuigreet (текстовый менеджер входа).
{ pkgs, vars, lib, ... }:
let
  tuigreet = pkgs.tuigreet;

  # Скрипт запуска tuigreet со всеми параметрами.
  tuigreet-launch = pkgs.writeShellScript "tuigreet-launch" ''
    exec ${tuigreet}/bin/tuigreet \
      --time \
      --time-format '${vars.greeter.timeFormat}' \
      --sessions /run/current-system/sw/share/wayland-sessions \
      --remember \
      --remember-user-session \
      --asterisks \
      --greeting '${vars.greeter.greeting}' \
      --container-padding ${toString vars.greeter.containerPadding} \
      --power-shutdown 'systemctl poweroff' \
      --power-reboot 'systemctl reboot'
  '';
  # Пояснение параметров:
  #   --time / --time-format       часы на экране входа
  #   --sessions                   где искать Wayland-сессии (запись Hyprland)
  #   --remember                   запоминать последнего пользователя
  #   --remember-user-session      запоминать выбранную сессию пользователя
  #   --asterisks                  показывать * при вводе пароля
  #   --greeting                   приветствие
  #   --container-padding          внутренний отступ окна
  #   --power-shutdown/--power-reboot  команды для кнопок питания
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet-launch}";
        user = "greeter";
      };
      # Управление мониторами экрана входа: включён только primaryOutput.
      # ВНИМАНИЕ: ключа `outputs` в greetd не существует — вероятно, он
      # игнорируется. Оставлено как было; монитор экрана входа в реальности
      # определяет ядро/композитор.
      outputs =
        [ { connector = vars.greeter.primaryOutput; primary = true; } ]
        ++ map (m: { connector = m.output; enabled = false; })
          (lib.filter (m: m.output != vars.greeter.primaryOutput) vars.monitors);
    };
  };

  # Настройки службы greetd, чтобы tuigreet нормально работал на tty и не
  # засорял экран логами (рекомендация сообщества NixOS).
  systemd.services.greetd.serviceConfig = {
    Type = "idle";               # стартовать после окончания вывода загрузки
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";   # ошибки — в журнал, а не на экран
    TTYReset = true;             # сбросить tty перед запуском
    TTYVHangup = true;           # закрыть чужие процессы на tty
    TTYVTDisallocate = true;     # очистить буфер консоли
  };

  environment.systemPackages = [ tuigreet ];
}
