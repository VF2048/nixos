{
  lib,
  ...
}:
let
  inherit (lib.generators) mkLuaInline;

  # bind com SUPER (variável Lua `mod`, definida em default.nix)
  m = keys: dsp: {
    _args = [
      (mkLuaInline "mod .. \" + ${keys}\"")
      (mkLuaInline dsp)
    ];
  };

  # bind com teclas fixas
  k = keys: dsp: {
    _args = [
      keys
      (mkLuaInline dsp)
    ];
  };
in
{
  wayland.windowManager.hyprland.settings = {

    bind = [
    # killactive / exit / togglefloating / pseudo / togglesplit
    (m "GRAVE" "hl.dsp.exec_cmd(\"kitty\")")
    (m "Q" "hl.dsp.window.close()")
    (m "M" "hl.dsp.exit()")
    (m "V" "hl.dsp.window.float()")
    (m "P" "hl.dsp.layout(\"pseudo\")")  # dwindle pseudo
    # (m "J" "hl.dsp.layout(\"togglesplit\")") -- dwindle togglesplit (закомментировано)

    # exec программы
    (m "RETURN" "hl.dsp.exec_cmd(\"wezterm\")")
    (m "E" "hl.dsp.exec_cmd(\"dolphin\")")
    # (m "R" "hl.dsp.exec_cmd(\"wofi --show drun\")")
    # (m "SHIFT + R" "hl.dsp.exec_cmd(\"rofi -show drun\")")
    (m "A" "hl.dsp.exec_cmd(\"remmina\")")
    (m "F" "hl.dsp.exec_cmd(\"firefox\")")
    (m "T" "hl.dsp.exec_cmd(\"kitty --directory ~/nixos -- fish -c  'nix run .#tg-ws-proxy -- --port 1080; exec fish'\")")

    # Caelestia Integrations
    (m "SHIFT + E" "hl.dsp.exec_cmd(\"pkill fuzzel || caelestia emoji -p\")")
    (m "X" "hl.dsp.global(\"caelestia:session\")")
    (m "R" "hl.dsp.global(\"caelestia:launcher\")")
    (m "N" "hl.dsp.global(\"caelestia:sidebar\")")
    (m "L" "hl.dsp.global(\"caelestia:lock\")")
    # (m "S" "hl.dsp.global(\"caelestia:screenshotFreeze\")")
    (m "C" "hl.dsp.exec_cmd(\"pkill fuzzel || caelestia clipboard\")")
    (m "SHIFT + A" "hl.dsp.global(\"caelestia:showall\")")
    # (m "SHIFT + F" "hl.dsp.dispatch(\"fullscreen\")")
    # (m "SHIFT + F" "hl.dsp.exec_cmd(\"hyprctl dispatch fullscreen 0\")")

    # movefocus (Перемещение фокуса стрелками)
    (m "left" "hl.dsp.focus({ direction = \"left\" })")
    (m "right" "hl.dsp.focus({ direction = \"right\" })")
    (m "up" "hl.dsp.focus({ direction = \"up\" })")
    (m "down" "hl.dsp.focus({ direction = \"down\" })")

    # workspace (Переключение воркспейсов 1-10)
    (m "1" "hl.dsp.focus({ workspace = \"1\" })")
    (m "2" "hl.dsp.focus({ workspace = \"2\" })")
    (m "3" "hl.dsp.focus({ workspace = \"3\" })")
    (m "4" "hl.dsp.focus({ workspace = \"4\" })")
    (m "5" "hl.dsp.focus({ workspace = \"5\" })")
    (m "6" "hl.dsp.focus({ workspace = \"6\" })")
    (m "7" "hl.dsp.focus({ workspace = \"7\" })")
    (m "8" "hl.dsp.focus({ workspace = \"8\" })")
    (m "9" "hl.dsp.focus({ workspace = \"9\" })")
    (m "0" "hl.dsp.focus({ workspace = \"10\" })")

    # movetoworkspace (Перенос окна на воркспейс с переключением фокуса)
    (m "SHIFT + 1" "hl.dsp.window.move({ workspace = \"1\", follow = true })")
    (m "SHIFT + 2" "hl.dsp.window.move({ workspace = \"2\", follow = true })")
    (m "SHIFT + 3" "hl.dsp.window.move({ workspace = \"3\", follow = true })")
    (m "SHIFT + 4" "hl.dsp.window.move({ workspace = \"4\", follow = true })")
    (m "SHIFT + 5" "hl.dsp.window.move({ workspace = \"5\", follow = true })")
    (m "SHIFT + 6" "hl.dsp.window.move({ workspace = \"6\", follow = true })")
    (m "SHIFT + 7" "hl.dsp.window.move({ workspace = \"7\", follow = true })")
    (m "SHIFT + 8" "hl.dsp.window.move({ workspace = \"8\", follow = true })")
    (m "SHIFT + 9" "hl.dsp.window.move({ workspace = \"9\", follow = true })")
    (m "SHIFT + 0" "hl.dsp.window.move({ workspace = \"10\", follow = true })")

    # Special workspace (Специальный воркспейс / scratchpad)
    # (m "S" "hl.dsp.special_workspace({ name = \"special:magic\", toggle = true })")
    (m "S" "hl.dsp.workspace.toggle_special(\"magic\")")
    (m "SHIFT + S" "hl.dsp.window.move({ workspace = \"special:magic\", follow = true })")

    # Колесо мыши (Прокрутка воркспейсов)
    (m "mouse_down" "hl.dsp.focus({ workspace = \"e+1\" })")
    (m "mouse_up" "hl.dsp.focus({ workspace = \"e-1\" })")

    # bindm: Перетаскивание и ресайз мышью
    (m "mouse:272" "hl.dsp.window.drag()")
    (m "mouse:273" "hl.dsp.window.resize()")
    ];
  };
}
