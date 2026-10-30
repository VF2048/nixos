# =============================================================================
# vars.nix — ЕДИНЫЙ файл всех настраиваемых и повторяющихся значений.
#
# Это обычный attrset без зависимостей (не модуль NixOS). Он импортируется
# в flake.nix один раз и передаётся во ВСЕ модули (и NixOS, и Home Manager)
# через аргумент `vars`:
#
#     { vars, ... }: { users.users.${vars.user.name} = { ... }; }
#
# Правило: если значение встречается в двух и более файлах ИЛИ вы захотите
# поменять его при переезде на другую машину / тему — оно живёт здесь.
# Пакеты (pkgs.*) в vars хранить нельзя, поэтому для шрифтов и курсора здесь
# лежат только ИМЕНА; соответствующие пакеты указаны в modules/home/theme/.
# =============================================================================
{
  # ---------------------------------------------------------------------------
  # Пользователь
  # ---------------------------------------------------------------------------
  user = {
    # Логин. Используется в users.users, в Home Manager и в путях.
    name = "vfok";
    # Отображаемое имя пользователя (GECOS) — показывается в менеджерах входа.
    description = "vfok";
    # Группы пользователя:
    #   wheel          — право на sudo
    #   networkmanager — управление сетью без root
    #   video / audio  — доступ к GPU-устройствам и звуку
    #   plugdev / uucp — доступ к USB-устройствам и последовательным портам
    #   docker         — доступ к docker-сокету (ВНИМАНИЕ: эквивалентно root)
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "plugdev" "uucp" "docker" ];
  };

  # ---------------------------------------------------------------------------
  # Хост и локаль
  # ---------------------------------------------------------------------------
  host = {
    # Имя машины в сети (networking.hostName).
    hostName = "nixos";
    # Имя конфигурации в flake: сборка выполняется как `--flake .#main`.
    # Если сделать его равным hostName, можно будет писать просто `--flake .`.
    flakeName = "main";
    # Архитектура процессора.
    system = "x86_64-linux";
    # stateVersion системы. НЕ повышайте при обновлении nixpkgs — это версия
    # первой установки (влияет на формат состояния сервисов, например БД).
    stateVersion = "25.05";
    # stateVersion Home Manager (то же правило).
    homeStateVersion = "26.05";
    # Часовой пояс.
    timeZone = "Europe/Moscow";
    # Основная локаль интерфейса.
    defaultLocale = "en_US.UTF-8";
    # Локаль для формата дат, чисел, валюты, бумаги и т.д. (LC_*).
    regionalLocale = "ru_RU.UTF-8";
  };

  # ---------------------------------------------------------------------------
  # Переключатели функций. false = модуль вообще не подключается.
  # ---------------------------------------------------------------------------
  features = {
    waybar = true;     # панель waybar (в Hyprland не автозапускается: у вас Caelestia)
    hyprlock = true;   # экран блокировки hyprlock (Caelestia имеет свой lock)
    # Stylix сейчас НЕ включён (в исходной конфигурации не было stylix.enable).
    # true — Stylix начнёт красить GTK/Qt/kitty/и т.д. по обоям (см. theme/stylix.nix).
    stylix = false;
    zapret = true;     # обход блокировок Discord/YouTube (служба root)
    steam = true;      # Steam + gamescope
    docker = true;     # Docker + NVIDIA container toolkit
    postgresql = true; # локальный PostgreSQL
    hiddify = true;    # VPN-клиент Hiddify (AppImage)
  };

  # ---------------------------------------------------------------------------
  # Пути. Относительные пути считаются от домашней директории ($HOME).
  # ---------------------------------------------------------------------------
  paths = {
    # Каталог с flake-конфигурацией (используется в бинде запуска tg-ws-proxy).
    flakeDir = "nixos";
    # Папка с обоями репозитория (копируется в ~/Pictures/Wallpapers).
    wallpaperDir = ./wallpapers;
    wallpaperTarget = "Pictures/Wallpapers";
    # Обои, от которых Stylix строит палитру (если features.stylix = true).
    wallpaper = ./wallpapers/mountainscapedark.jpg;
    # Аватар для hyprlock (файл нужно положить самостоятельно).
    faceImage = ".config/face.jpg";
    # Кэш шейдеров Mesa/Vulkan — в домашней директории, чтобы не терялся.
    mesaCache = ".cache/mesa_shader_cache";
  };

  # ---------------------------------------------------------------------------
  # Приложения по умолчанию (используются в биндах Hyprland и waybar)
  # ---------------------------------------------------------------------------
  apps = {
    terminal = "kitty";
    terminalFontSize = 12;
    browser = "firefox";
    fileManager = "thunar";
    remoteDesktop = "remmina";
  };

  # ---------------------------------------------------------------------------
  # Ввод (клавиатура / мышь)
  # ---------------------------------------------------------------------------
  input = {
    kbLayout = "us,ru";                  # раскладки через запятую
    kbOptions = "grp:alt_shift_toggle";  # переключение раскладки Alt+Shift
    followMouse = 1;                     # фокус следует за курсором мыши
    sensitivity = -0.7;                  # чувствительность указателя (-1.0 … 1.0)
    naturalScroll = false;               # «натуральная» прокрутка тачпада
    # Отдельная чувствительность для конкретной мыши (имя из `hyprctl devices`).
    # ВНИМАНИЕ: "epic-mouse-v1" — значение из примера документации Hyprland;
    # скорее всего такого устройства у вас нет, подставьте своё имя.
    mouseDevice = { name = "epic-mouse-v1"; sensitivity = -1; };
  };

  # ---------------------------------------------------------------------------
  # Мониторы. Порядок = порядок в конфиге Hyprland.
  #   output     — имя выхода (hyprctl monitors)
  #   position   — положение: "0x0" или относительное "auto-left"/"auto-right"
  #   workspaces — какие рабочие столы закреплены за монитором
  # ---------------------------------------------------------------------------
  monitors = [
    { output = "DP-2";     position = "0x0";        workspaces = [ 1 2 ]; }
    { output = "DP-1";     position = "auto-right"; workspaces = [ 3 ];   }
    { output = "HDMI-A-1"; position = "auto-left";  workspaces = [ 4 ];   }
  ];

  # ---------------------------------------------------------------------------
  # Hyprland: внешний вид и поведение
  # ---------------------------------------------------------------------------
  hyprland = {
    modKey = "SUPER";   # главный модификатор всех горячих клавиш
    layout = "dwindle"; # тайлинг: dwindle (бинарное дерево) или master
    gapsIn = 5;         # отступ между окнами, px
    gapsOut = 20;       # отступ от краёв экрана, px
    borderSize = 2;     # толщина рамки окна, px
    rounding = 10;      # радиус скругления углов окон, px
    shadow = { enabled = true; range = 4; renderPower = 3; };
    blur = { enabled = true; size = 3; passes = 1; vibrancy = 0.1696; };
  };

  # ---------------------------------------------------------------------------
  # Простой (Caelestia idle): значения в секундах
  # ---------------------------------------------------------------------------
  idle = {
    lockAfter = 1800;     # 30 минут — блокировка экрана
    suspendAfter = 7200;  # 2 часа — `systemctl suspend`
                          # ВНИМАНИЕ: в modules/nixos/desktop.nix цель suspend
                          # отключена, поэтому эта команда сейчас не сработает.
  };

  # ---------------------------------------------------------------------------
  # Тема: курсор, шрифты, иконки, прозрачность
  # ---------------------------------------------------------------------------
  theme = {
    polarity = "dark";
    opacity = { terminal = 0.9; applications = 0.9; };
    # Курсор. Пакет — pkgs.bibata-cursors (см. theme/cursor.nix).
    # Раньше в конфигурации одновременно были Bibata-Modern-Ice (Stylix) и
    # Bibata-Modern-Classic (автозапуск Hyprland). Реально применялся Classic,
    # его и оставляем единым значением.
    cursor = { name = "Bibata-Modern-Classic"; size = 24; };
    # Шрифты (пакеты — в theme/fonts.nix; при смене имени смените и пакет).
    fonts = {
      monospace = "JetBrains Mono";
      sansSerif = "Montserrat";
      serif = "Montserrat";
      sizes = { applications = 12; terminal = 15; desktop = 11; popups = 12; };
    };
    # Тема иконок: GTK и Qt называют Papirus по-разному.
    iconThemeGtk = "Papirus-Dark";
    iconThemeQt = "Papirus";
  };

  # ---------------------------------------------------------------------------
  # Сеть и порты
  # ---------------------------------------------------------------------------
  network = {
    sshPort = 22;
    # Диапазон портов KDE Connect (TCP и UDP).
    kdeconnectPorts = { from = 1714; to = 1764; };
  };

  # Telegram WebSocket-прокси (запускается биндом SUPER+T через `nix run`).
  tgProxy = {
    port = 1080;
    # ВНИМАНИЕ: секрет лежит в git-репозитории. Значение выглядит как
    # последовательность символов — замените его на случайное (32 hex-символа,
    # `openssl rand -hex 16`) и по возможности вынесите из репозитория.
    secret = "4a3f2b1c5d6e7f8a9b0c1d2e3f4a5b6c";
  };

  # ---------------------------------------------------------------------------
  # zapret (обход блокировок Discord/YouTube)
  # ---------------------------------------------------------------------------
  zapret = {
    # Стратегия из каталога configs апстрима.
    configName = "general(ALT12)";
    # Фильтр игровых портов: "null" (выкл.), "all", "tcp" или "udp".
    gameFilter = "udp";
    # Дополнительные домены для обхода (list-general-user.txt).
    # "test.org" и "mysite.net" — заглушки из примера апстрима.
    listGeneral = [ "ravesli.com" "test.org" "mysite.net" ];
    # Домены-исключения (list-exclude-user.txt): Steam и Dead by Daylight.
    # zapret сопоставляет домен вместе с поддоменами, поэтому записи вида
    # "api.bhvrdbd.com" при наличии "bhvrdbd.com" избыточны (оставлены как были).
    listExclude = [
      "steamcommunity.com" "steampowered.com" "steam-api.com" "valve.net"
      "steamcontent.com" "steamstatic.com" "api.steampowered.com"
      "bhvrdbd.com" "api.bhvrdbd.com" "latest.live.dbd.bhvronline.com"
      "cdn.live.dbd.bhvronline.com" "steam.live.bhvronline.com" "uploads.bhvrdbd.com"
      "easy.ac" "eac.com" "anticheat.online" "module.eac.com"
      "modules-cdn.eac-prod.on.epicgames.com" "download-alt.easyanticheat.net"
      "download.eac-cdn.com" "cdn.bhvrdbd.com" "dbd.bhvronline.com"
      "dbd.live.bhvrdbd.com" "steam.live.bhvrdbd.com" "epic.live.bhvrdbd.com"
      "ps4.live.bhvrdbd.com" "ps5.live.bhvrdbd.com" "switch.live.bhvrdbd.com"
      "xsx.live.bhvrdbd.com" "cdn.live.bhvrdbd.com" "patchnote.bhvrdbd.com"
      "bhvronline.com" "bhvr.com" "easyanticheat.com"
    ];
  };

  # ---------------------------------------------------------------------------
  # Hiddify (VPN-клиент, скачивается как AppImage)
  # ---------------------------------------------------------------------------
  hiddify = {
    version = "4.1.1";
    # Хэш релиза. При смене версии поставьте пустую строку "" — Nix при сборке
    # выдаст правильное значение в строке `got:`.
    hash = "sha256-6yu2wIlxuY4tCgH8W2R+KboXsWYRScyfl+2g53v1vcM=";
  };

  # ---------------------------------------------------------------------------
  # Docker
  # ---------------------------------------------------------------------------
  docker = {
    # Атрибут пакета в nixpkgs. docker_25 — устаревшая ветка (EOL); если пакет
    # исчезнет из nixpkgs, замените на актуальную версию.
    package = "docker_25";
    # Зеркала реестра (запросы к Docker Hub идут через них по порядку).
    registryMirrors = [
      "https://mirror.gcr.io"
      "https://daocloud.io"
      "https://huecker.io"
    ];
    # Каталог спецификаций CDI (нужен nvidia-container-toolkit).
    cdiSpecDirs = [ "/var/run/cdi" ];
  };

  # ---------------------------------------------------------------------------
  # PostgreSQL
  # ---------------------------------------------------------------------------
  postgres = {
    package = "postgresql_16"; # или postgresql_15 / postgresql_17
    # Имя БД и роли (шаблонное "myuser" — замените на своё).
    database = "myuser";
    role = "myuser";
  };

  # ---------------------------------------------------------------------------
  # Звук (PipeWire)
  # ---------------------------------------------------------------------------
  audio = {
    sampleRate = 48000;  # единственная разрешённая частота дискретизации, Гц
    quantum = 1024;      # размер буфера по умолчанию (меньше — ниже задержка)
    minQuantum = 32;
    maxQuantum = 8192;
  };

  # ---------------------------------------------------------------------------
  # Окружение сессии
  # ---------------------------------------------------------------------------
  session = {
    # Максимальный размер кэша шейдеров Mesa.
    mesaCacheSize = "10G";
  };

  # ---------------------------------------------------------------------------
  # Экран входа (greetd + tuigreet)
  # ---------------------------------------------------------------------------
  greeter = {
    primaryOutput = "DP-1";          # единственный включённый монитор на экране входа
    greeting = "Welcome";
    timeFormat = "%H:%M  %A %d %B";  # формат часов
    containerPadding = 2;
  };
}
