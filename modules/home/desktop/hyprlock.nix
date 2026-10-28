# hyprlock — экран блокировки. (Пароль проверяется через PAM-сервис,
# объявленный в modules/nixos/security.nix. Caelestia использует свой lock.)
{ config, vars, ... }: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true; # без индикатора загрузки
        grace = 10;                 # 10 с после блокировки можно разблокировать без пароля
        hide_cursor = true;         # скрывать курсор
        no_fade_in = false;         # плавное появление экрана блокировки
      };

      # Аватар по центру-сверху. Файл (vars.paths.faceImage) нужно создать самому.
      image = [
        {
          path = "${config.home.homeDirectory}/${vars.paths.faceImage}";
          size = 150;                   # диаметр, px
          border_size = 4;
          border_color = "rgb(0C96F9)";
          rounding = -1;                # отрицательное значение = идеальный круг
          position = "0, 200";          # смещение от центра
          halign = "center";
          valign = "center";
        }
      ];

      # ВНИМАНИЕ: фон (background) и поле ввода пароля (input-field) в исходной
      # конфигурации закомментированы, поэтому экран hyprlock показывает только
      # аватар и не отображает ввод. Если планируете пользоваться hyprlock всерьёз,
      # раскомментируйте их из истории git или добавьте заново.
    };
  };
}
