# Горячие клавиши Hyprland (Lua-API). Главный модификатор (SUPER) задан в
# settings.nix; приложения — в vars.nix → apps.
{ lib, vars, ... }:
let
  inherit (lib.generators) mkLuaInline;
  apps = vars.apps;

  # m KEYS DISPATCHER — bind вида `mod + KEYS`; результат — Lua-вставка.
  m = keys: dsp: {
    _args = [
      (mkLuaInline "mod .. \" + ${keys}\"")
      (mkLuaInline dsp)
    ];
  };

  # Короткая запись запуска программы: hl.dsp.exec_cmd("команда").
  exec = cmd: "hl.dsp.exec_cmd(\"${cmd}\")";

  # Номера рабочих столов 1..10. Клавиша "0" соответствует столу 10.
  workspaceNumbers = lib.genList (n: n + 1) 10;
  keyFor = n: toString (lib.mod n 10);

  # Запуск tg-ws-proxy в терминале из каталога flake (через `nix run`).
  tgProxyCmd = "${apps.terminal} --directory ~/${vars.paths.flakeDir} -- fish -c  'nix run .#tg-ws-proxy -- --port ${toString vars.tgProxy.port} --secret ${vars.tgProxy.secret}; exec fish'";
in
{
  wayland.windowManager.hyprland.settings.bind = [
    # --- Окна ---------------------------------------------------------------
    (m "Q" "hl.dsp.window.close()")             # закрыть окно
    (m "M" "hl.dsp.exit()")                     # выйти из Hyprland
    (m "V" "hl.dsp.window.float()")             # плавающее окно вкл/выкл
    (m "P" "hl.dsp.layout(\"pseudo\")")         # pseudo-режим (dwindle)
    # (m "J" "hl.dsp.layout(\"togglesplit\")")  # смена направления деления (отключено)

    # --- Запуск программ (имена — в vars.nix → apps) ------------------------
    (m "GRAVE" (exec apps.terminal))            # терминал (SUPER+`)
    (m "RETURN" (exec apps.terminal))           # терминал (SUPER+Enter)
    # ИСПРАВЛЕНО: раньше Enter запускал wezterm, а E — dolphin, но ни одной из
    # этих программ в системе нет. Теперь используются kitty и thunar.
    (m "E" (exec apps.fileManager))             # файловый менеджер
    (m "A" (exec apps.remoteDesktop))           # удалённый рабочий стол
    (m "F" (exec apps.browser))                 # браузер
    (m "T" (exec tgProxyCmd))                   # Telegram-прокси
    # (m "R" (exec "wofi --show drun"))         # wofi (отключено: используется Caelestia)
    # (m "SHIFT + R" (exec "rofi -show drun"))  # rofi (отключено)

    # --- Caelestia ----------------------------------------------------------
    (m "SHIFT + E" (exec "pkill fuzzel || caelestia emoji -p")) # выбор эмодзи
    (m "X" "hl.dsp.global(\"caelestia:session\")")              # меню сессии (выход/сон)
    (m "R" "hl.dsp.global(\"caelestia:launcher\")")             # лаунчер приложений
    (m "N" "hl.dsp.global(\"caelestia:sidebar\")")              # боковая панель
    (m "L" "hl.dsp.global(\"caelestia:lock\")")                 # блокировка экрана
    (m "Z" "hl.dsp.global(\"caelestia:screenshotFreeze\")")     # скриншот области
    (m "C" (exec "pkill fuzzel || caelestia clipboard"))        # история буфера обмена
    (m "SHIFT + A" "hl.dsp.global(\"caelestia:showall\")")      # все панели Caelestia
    # (m "SHIFT + F" "hl.dsp.dispatch(\"fullscreen\")")         # полноэкранный режим (отключено)
    (m "SHIFT + R" (exec "rofi -show drun")) 

    # --- Scratchpad (специальный рабочий стол "magic") ----------------------
    (m "S" "hl.dsp.workspace.toggle_special(\"magic\")")                              # показать/скрыть
    (m "SHIFT + S" "hl.dsp.window.move({ workspace = \"special:magic\", follow = true })") # убрать окно туда

    # --- Колесо мыши: переключение рабочих столов ---------------------------
    (m "mouse_down" "hl.dsp.focus({ workspace = \"e+1\" })") # следующий
    (m "mouse_up" "hl.dsp.focus({ workspace = \"e-1\" })")   # предыдущий

    # --- Мышь: перетаскивание и изменение размера окон ----------------------
    (m "mouse:272" "hl.dsp.window.drag()")    # ЛКМ — переместить
    (m "mouse:273" "hl.dsp.window.resize()")  # ПКМ — изменить размер
  ]
  # --- Фокус стрелками -------------------------------------------------------
  ++ map (d: m d "hl.dsp.focus({ direction = \"${d}\" })") [ "left" "right" "up" "down" ]
  # --- Переключение на рабочий стол 1–10 (SUPER+1…0) -------------------------
  ++ map (n: m (keyFor n) "hl.dsp.focus({ workspace = \"${toString n}\" })") workspaceNumbers
  # --- Перенос окна на стол 1–10 с переходом (SUPER+SHIFT+1…0) --------------
  ++ map (n: m "SHIFT + ${keyFor n}" "hl.dsp.window.move({ workspace = \"${toString n}\", follow = true })") workspaceNumbers;
}
