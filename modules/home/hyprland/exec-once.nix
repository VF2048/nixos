{ host, pkgs, ... }:
{
  wayland.windowManager.hyprland.settings = {
    exec_once = [
      # "killall -q waybar;sleep .5 && waybar"
      # "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland QT_QPA_PLATFORMTHEME=gtk2"
      # "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP QT_QPA_PLATFORMTHEME"
    ];
  };
}

