# superfile — терминальный файловый менеджер (модуль programs.superfile из
# самого Home Manager; отдельный flake-input больше не нужен).
#
# Формат каждой горячей клавиши: [ "основная" "дополнительная" ].
# Пустая строка "" означает, что второй клавиши нет.
{ ... }: {
  programs.superfile = {
    enable = true;

    # Основные настройки (записываются в config.toml).
    settings = {
      theme = "catppuccin";    # цветовая тема
      border_type = "rounded"; # скруглённые рамки панелей
    };

    hotkeys = {
      # --- Глобальные горячие клавиши -------------------------------------
      global = {
        confirm = [ "enter" "" ];           # подтвердить / открыть
        quit = [ "ctrl+c" "" ];             # выйти из программы
        cd_quit = [ "Q" "" ];               # выйти и перейти в текущий каталог в оболочке

        list_up = [ "k" "" ];               # курсор вверх (в стиле vim)
        list_down = [ "j" "" ];             # курсор вниз
        page_up = [ "pgup" "" ];            # страница вверх
        page_down = [ "pgdown" "" ];        # страница вниз

        create_new_file_panel = [ "n" "" ];        # открыть новую файловую панель
        close_file_panel = [ "q" "" ];             # закрыть текущую панель
        next_file_panel = [ "tab" "" ];            # следующая панель
        previous_file_panel = [ "shift+tab" "" ];  # предыдущая панель
        split_file_panel = [ "N" "" ];             # разделить панель
        toggle_file_preview_panel = [ "f" "" ];    # показать/скрыть предпросмотр
        open_sort_options_menu = [ "o" "" ];       # меню сортировки
        toggle_reverse_sort = [ "R" "" ];          # обратить порядок сортировки

        focus_on_process_bar = [ "ctrl+p" "" ];    # фокус на панели процессов
        focus_on_sidebar = [ "ctrl+s" "" ];        # фокус на боковой панели
        focus_on_metadata = [ "ctrl+d" "" ];       # фокус на метаданных файла

        file_panel_item_create = [ "a" "" ];       # создать файл/каталог
        file_panel_item_rename = [ "r" "" ];       # переименовать

        copy_items = [ "y" "" ];                   # копировать
        cut_items = [ "x" "" ];                    # вырезать
        paste_items = [ "p" "" ];                  # вставить
        delete_items = [ "d" "" ];                 # удалить в корзину
        permanently_delete_items = [ "D" "" ];     # удалить навсегда

        extract_file = [ "ctrl+e" "" ];            # распаковать архив
        compress_file = [ "ctrl+a" "" ];           # упаковать в архив

        open_file_with_editor = [ "e" "" ];                # открыть файл в редакторе
        open_current_directory_with_editor = [ "E" "" ];   # открыть каталог в редакторе

        pinned_directory = [ "P" "" ];                 # закрепить каталог в боковой панели
        toggle_dot_file = [ "." "" ];                  # показать/скрыть скрытые файлы
        change_panel_mode = [ "m" "" ];                # режим панели (просмотр/выделение)
        open_help_menu = [ "?" "" ];                   # справка по клавишам
        open_spf_prompt = [ ">" "" ];                  # командная строка superfile
        open_command_line = [ ":" "" ];                # командная строка оболочки
        open_zoxide = [ "z" "" ];                      # быстрый переход через zoxide
        copy_path = [ "Y" "" ];                        # скопировать путь к файлу
        copy_present_working_directory = [ "c" "" ];   # скопировать путь текущего каталога
        toggle_footer = [ "ctrl+f" "" ];               # показать/скрыть нижнюю панель
      };

      # --- Режим ввода текста ---------------------------------------------
      typing = {
        confirm_typing = [ "enter" "" ];   # подтвердить введённый текст
        cancel_typing = [ "esc" "" ];      # отменить ввод
      };

      # --- Обычный режим --------------------------------------------------
      normal = {
        parent_directory = [ "-" "" ];     # перейти в родительский каталог
        search_bar = [ "/" "" ];           # строка поиска
      };

      # --- Режим выделения ------------------------------------------------
      selection = {
        file_panel_select_mode_items_select_down = [ "J" "" ];  # выделить вниз
        file_panel_select_mode_items_select_up = [ "K" "" ];    # выделить вверх
        file_panel_select_all_items = [ "A" "" ];               # выделить всё
      };
    };
  };
}
