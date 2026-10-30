# Загрузчик и модули ядра общего назначения.
{ ... }: {
  # systemd-boot — простой UEFI-загрузчик.
  boot.loader.systemd-boot.enable = true;
  # Разрешаем установщику менять переменные EFI (создавать запись в меню BIOS).
  boot.loader.efi.canTouchEfiVariables = true;

  # Swap-раздел, с которого возобновлять систему после гибернации.
  boot.resumeDevice = "/dev/disk/by-uuid/76a1cb13-4529-46ab-a351-c5bdc1ab142a";

  # Модуль ядра TUN нужен VPN-клиентам (Hiddify, sing-box) для виртуального
  # сетевого интерфейса.
  boot.kernelModules = [ "tun" ];
}
