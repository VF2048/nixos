# Опции Neovim (:help option-list) и глобальные переменные.
{
  programs.nixvim = {
    globals = {
      # Отключаем провайдеры языков, которые не используются (ускоряет запуск
      # и убирает предупреждения :checkhealth).
      loaded_ruby_provider = 0;
      loaded_perl_provider = 0;
      loaded_python_provider = 0; # Python 2
      loaded_node_provider = 0;
      # Размер буфера прокрутки встроенного терминала (строк).
      terminal_scrollback_buffer_size = 100000;
    };

    clipboard = {
      # Системный буфер обмена Wayland через wl-copy/wl-paste.
      # register = "unnamedplus"; # раскомментируйте, чтобы y/p работали с системным буфером
      providers.wl-copy.enable = true;
    };

    opts = {
      updatetime = 100; # задержка (мс) до записи swap и срабатывания CursorHold — быстрее подсказки

      # --- Номера строк и окна ---
      relativenumber = true;  # относительные номера строк
      number = true;          # абсолютный номер текущей строки
      hidden = true;          # закрытые буферы остаются в памяти
      mouse = "a";            # мышь во всех режимах
      mousemodel = "extend";  # правая кнопка мыши расширяет выделение
      splitbelow = true;      # новое горизонтальное окно — снизу
      splitright = true;      # новое вертикальное окно — справа

      # --- Файлы ---
      swapfile = false;       # не создавать swap-файлы
      #modeline = true;       # теги вида `vim:ft=sh`
      #modelines = 100;       # сколько строк просматривать на предмет modeline
      undofile = false;       # не сохранять историю отмен между сессиями

      # --- Поиск ---
      incsearch = true;       # подсвечивать совпадения по мере ввода
      inccommand = "split";   # предпросмотр :s/замена в отдельном окне
      ignorecase = true;      # игнорировать регистр при поиске...
      smartcase = true;       # ...пока в шаблоне нет заглавных букв

      # --- Отображение ---
      scrolloff = 8;          # держать 8 строк контекста вокруг курсора
      cursorline = false;     # не подсвечивать строку курсора
      cursorcolumn = false;   # не подсвечивать столбец курсора
      signcolumn = "yes";     # колонка знаков (диагностика, git) всегда видна
      #colorcolumn = "100";   # вертикальная линия на 100-м столбце
      laststatus = 3;         # одна глобальная строка состояния на все окна
      fileencoding = "utf-8"; # кодировка записываемых файлов
      termguicolors = true;   # 24-битный цвет в терминале
      spell = false;          # проверка орфографии выключена
      wrap = false;           # не переносить длинные строки

      # --- Отступы ---
      tabstop = 4;            # ширина символа Tab — 4 пробела
      shiftwidth = 4;         # шаг авто-отступа — 4 пробела
      expandtab = true;       # вставлять пробелы вместо Tab
      autoindent = true;      # копировать отступ предыдущей строки
      textwidth = 0;          # 0 = не переносить строки автоматически

      # --- Складки ---
      foldlevel = 99;         # все складки по умолчанию раскрыты

      # --- Автодополнение ---
      completeopt = [ "menu" "menuone" "noselect" "preview" ]; # меню даже для одного варианта, без авто-выбора
      virtualedit = "block";  # в блочном режиме курсор может уходить за конец строки
      shadafile = "NONE";     # не сохранять shada (историю команд/регистров) между запусками
    };

    # Вторая цветовая схема (см. предупреждение в default.nix).
    colorschemes.onedark = {
      enable = true;
      settings = {
        transparent = true;       # прозрачный фон
        ending_tildes = true;     # показывать ~ после конца буфера
        code_style.comments = "none"; # комментарии без курсива/подчёркивания
      };
    };
  };
}
