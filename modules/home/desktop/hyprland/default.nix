# Hyprland (Wayland-композитор), пользовательская часть.
# Системная часть (запись сессии, UWSM, портал) — modules/nixos/desktop.nix.
{ ... }: {
  imports = [
    ./settings.nix   # основные настройки: ввод, вид, мониторы
    ./binds.nix      # горячие клавиши
    ./autostart.nix  # действия при старте сессии, курсор
  ];
}
