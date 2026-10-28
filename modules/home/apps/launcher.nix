# wofi — лаунчер приложений. (Основной лаунчер — Caelestia; бинды wofi/rofi
# в Hyprland закомментированы, но программа остаётся доступной.)
{ ... }: {
  programs.wofi = {
    enable = true;
    settings = {
      allow_images = true; # показывать иконки приложений
      image_size = 48;     # размер значков в пикселях
      mode = "drun";       # режим: список установленных приложений
    };
  };
}
