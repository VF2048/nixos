# Точка входа хоста "main".
# Здесь только список подключаемых файлов: всё содержимое — в modules/.
{ ... }: {
  imports = [
    # Сгенерирован `nixos-generate-config` (диски, модули ядра initrd, CPU).
    # Файл оставлен «чистым» — любые правки оборудования вынесены в
    # modules/nixos/hardware.nix, чтобы повторная генерация ничего не стирала.
    ./hardware-configuration.nix

    # Системный слой (то, что Home Manager сделать не может).
    ../../modules/nixos
  ];
}
