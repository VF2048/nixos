# Действия при запуске Hyprland и применение курсора в сессии.
# (Сам пакет и тема курсора — modules/home/theme/cursor.nix.)
{ lib, vars, ... }:
let
  lua = lib.generators.mkLuaInline; # вставка «сырого» Lua-кода в конфиг
  cursorName = vars.theme.cursor.name;
  cursorSize = toString vars.theme.cursor.size;
in
{
  wayland.windowManager.hyprland.settings.on = [
    {
      # Обработчик события hyprland.start — выполняется один раз при запуске.
      _args = [
        "hyprland.start"
        (lua ''
          function()
            -- Передать переменные окружения Wayland в systemd-сессию и D-Bus,
            -- чтобы пользовательские службы и порталы знали о текущем сеансе.
            hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
            -- Тема и размер курсора для X11/XWayland-приложений и самого Hyprland.
            hl.exec_cmd("hyprctl setenv XCURSOR_THEME ${cursorName}")
            hl.exec_cmd("hyprctl setenv XCURSOR_SIZE ${cursorSize}")
            hl.exec_cmd("hyprctl setcursor '${cursorName}' ${cursorSize}")
          end
        '')
      ];
    }
  ];
}
