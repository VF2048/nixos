# Пакеты пользователя. Раньше все они были в environment.systemPackages.
# Пакеты, у которых есть собственный модуль Home Manager (wofi, kitty, btop,
# superfile, fish, direnv, nixvim), устанавливаются через него и сюда не входят.
{ pkgs, inputs, vars, ... }: {
  home.packages = with pkgs; [
    # --- Запуск приложений и аудио ---
    rofi              # лаунчер приложений (резервный к wofi/Caelestia)
    pavucontrol       # микшер громкости PulseAudio/PipeWire (GUI)

    # --- Сеть и диагностика ---
    remmina           # клиент удалённого рабочего стола (RDP/VNC)
    ethtool           # параметры сетевых карт
    nmap              # сканер сети
    nftables          # утилита nft для правил firewall

    # --- Утилиты командной строки ---
    ripgrep           # быстрый grep
    eza               # современный ls (используется в алиасах fish)
    file

    # --- Разработка ---
    vscode            # редактор VS Code
    python3           # интерпретатор Python
    python3Packages.pip # ВНИМАНИЕ: pip вне виртуального окружения — анти-паттерн в Nix
    go                # компилятор Go
    gopls             # LSP-сервер Go
    gnumake
    uv

    # --- Общение и медиа ---
    spotify
    discord
    telegram-desktop

    # --- Оборудование ---
    solaar            # управление устройствами Logitech (udev-правила — в nixos/hardware.nix)

    # --- Оформление (иконки и Qt-интеграция) ---
    papirus-icon-theme
    adwaita-icon-theme
    qt6Packages.qt6ct # настройка тем Qt6
    libsForQt5.qt5ct  # настройка тем Qt5

    # --- Файлы и графика ---
    thunar            # файловый менеджер (бинд SUPER+E)
    pinta             # простой растровый редактор

    # --- Wayland ---
    wayland           # библиотеки Wayland

    bitwarden-desktop
    google-chrome
  ];
}
