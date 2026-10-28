# Переменные окружения пользовательской сессии и XDG.
# Раньше задавались на уровне системы (environment.sessionVariables).
{ config, vars, ... }:
let
  home = config.home.homeDirectory;

  sessionEnv = {
    # Кэш шейдеров Mesa/Vulkan хранить в домашней директории.
    MESA_SHADER_CACHE_DIR = "${home}/${vars.paths.mesaCache}";
    # Размер кэша шейдеров; большой лимит — чтобы кэш не очищался сам.
    MESA_GLSL_CACHE_MAX_SIZE = vars.session.mesaCacheSize;
  };
in
{
  # Для оболочек (fish/bash): переменные доступны в терминале.
  home.sessionVariables = sessionEnv;
  # Для графических приложений, запускаемых из Hyprland/UWSM через systemd
  # (они НЕ читают переменные оболочки) — пишется в ~/.config/environment.d.
  systemd.user.sessionVariables = sessionEnv;

  # Включает управление каталогами XDG (~/.config, ~/.local/share, ...).
  xdg.enable = true;
}
