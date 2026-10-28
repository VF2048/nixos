# Оборудование: видеокарта NVIDIA, bluetooth, беспроводные устройства Logitech.
# (Раньше эти блоки лежали в сгенерированном hardware-configuration.nix.)
{ config, ... }: {
  # Параметры ядра для NVIDIA на Wayland:
  #   nvidia-drm.modeset=1 — режим modesetting (нужен для Wayland);
  #   nvidia_drm.fbdev=1   — framebuffer-консоль на драйвере NVIDIA.
  boot.kernelParams = [ "nvidia-drm.modeset=1" "nvidia_drm.fbdev=1" ];

  # Включает OpenGL/Vulkan (hardware.graphics заменила hardware.opengl).
  hardware.graphics.enable = true;

  # Драйвер NVIDIA для Xorg и Wayland.
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting обязателен для Wayland-композиторов.
    modesetting.enable = true;
    # Управление питанием NVIDIA. Экспериментально: может ломать sleep/suspend.
    powerManagement.enable = true;
    # Тонкое управление питанием (выключает GPU в простое); только Turing+.
    powerManagement.finegrained = false;
    # Открытый модуль ядра NVIDIA (Turing и новее). false = проприетарный.
    # Для современных карт NVIDIA рекомендует open = true.
    open = false;
    # Утилита nvidia-settings.
    nvidiaSettings = true;
    # Версия драйвера: stable для текущего ядра.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Приёмник/клавиатуры Logitech Unifying: udev-правила для solaar.
  hardware.logitech.wireless.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true; # автоматически включать адаптер при старте системы
  };
}
