# Основные настройки Hyprland. Конфигурация генерируется в формате Lua
# (configType = "lua"), поэтому ключи верхнего уровня соответствуют Lua-API:
#   mod            — Lua-переменная с главным модификатором (используется в binds.nix);
#   config         — блок hl.config{...} (ввод, внешний вид, поведение);
#   device         — настройки конкретного устройства ввода;
#   monitor        — список мониторов;
#   workspace_rule — привязка рабочих столов к мониторам.
# Все значения берутся из vars.nix (input, hyprland, monitors).
{ lib, pkgs, vars, ... }:
let
  h = vars.hyprland;
  i = vars.input;
in
{
  # Копируем обои из репозитория в ~/Pictures/Wallpapers.
  home.file.${vars.paths.wallpaperTarget}.source = vars.paths.wallpaperDir;

  wayland.windowManager.hyprland = {
    enable = true;
    # Берём тот же пакет, что и системный модуль programs.hyprland.
    # (Чтобы избежать двух копий, можно поставить package = null — но с
    # configType = "lua" это не проверялось.)
    package = pkgs.hyprland;
    configType = "lua";
    xwayland.enable = true;
    # ВНИМАНИЕ: интеграция с systemd (hyprland-session.target) при запуске через
    # UWSM (withUWSM = true) может конфликтовать — документация Home Manager
    # рекомендует отключать. Оставлено как было.
    systemd.enable = true;

    settings = {
      # Главный модификатор; в binds.nix используется как `mod .. " + KEY"`.
      mod = { _var = h.modKey; };

      config = {
        # --- Ввод -----------------------------------------------------------
        input = {
          kb_layout = i.kbLayout;          # раскладки
          kb_options = i.kbOptions;        # переключение раскладки
          follow_mouse = i.followMouse;    # 1 = фокус следует за мышью
          sensitivity = i.sensitivity;     # чувствительность указателя
          touchpad.natural_scroll = i.naturalScroll;
        };

        # --- Раскладка окон и рамки ----------------------------------------
        general = {
          layout = h.layout;
          gaps_in = h.gapsIn;              # отступ между окнами
          gaps_out = h.gapsOut;            # отступ от краёв экрана
          border_size = h.borderSize;      # толщина рамки
          resize_on_border = false;        # менять размер окна, потянув за рамку
          # Цвета рамок не заданы — используются значения Hyprland по умолчанию.
        };

        # --- Оформление окон ------------------------------------------------
        decoration = {
          rounding = h.rounding;           # скругление углов
          active_opacity = 1.0;            # прозрачность активного окна
          inactive_opacity = 1.0;          # прозрачность неактивных окон
          shadow = {
            enabled = h.shadow.enabled;
            range = h.shadow.range;                # размер тени
            render_power = h.shadow.renderPower;   # резкость затухания тени
          };
          blur = {
            enabled = h.blur.enabled;
            size = h.blur.size;            # радиус размытия
            passes = h.blur.passes;        # число проходов
            vibrancy = h.blur.vibrancy;    # насыщенность цветов под размытием
          };
        };

        # --- Раскладка master -----------------------------------------------
        master.new_status = "master";      # новое окно становится главным

        # --- Прочее ---------------------------------------------------------
        misc = {
          initial_workspace_tracking = 2;  # новые окна остаются на рабочем столе приложения
          disable_hyprland_logo = true;    # убрать фоновую картинку/логотип Hyprland
        };
      };

      # Отдельная чувствительность для одной мыши. ВНИМАНИЕ: имя устройства —
      # значение из примера документации (см. vars.nix → input.mouseDevice).
      device = {
        name = i.mouseDevice.name;
        sensitivity = i.mouseDevice.sensitivity;
      };

      # Мониторы: разрешение — "preferred" (родное), масштаб — "auto".
      monitor = map (m: {
        output = m.output;
        mode = "preferred";
        position = m.position;
        scale = "auto";
      }) vars.monitors;

      # Правила рабочих столов: каждый стол закрепляется за своим монитором.
      workspace_rule = lib.concatMap (m:
        map (ws: { workspace = toString ws; monitor = m.output; }) m.workspaces
      ) vars.monitors;
    };
  };
}
