# Загрузчик и модули ядра общего назначения.
{ ... }: {
  # systemd-boot — простой UEFI-загрузчик.
  boot.loader.systemd-boot.enable = true;
  # Разрешаем установщику менять переменные EFI (создавать запись в меню BIOS).
  boot.loader.efi.canTouchEfiVariables = true;

  # Модуль ядра TUN нужен VPN-клиентам (Hiddify, sing-box) для виртуального
  # сетевого интерфейса.
  boot.kernelModules = [ "tun" ];
}
