{ inputs, pkgs, ... }: 
{
  home.packages = with pkgs; [
   wayland
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;

    systemd.enable = true;
    
    settings = {
     input = {
      kb_layout = "us,ru";
      kb_options = "grp:alt_shift_toggle";
      follow_mouse = 1;
      sensitivity = -0.7;
      touchpad = {
       natural_scroll = false;
      };
     };

     general = {
      "$mainMod" = "SUPER";
      layout = "dwindle";
      gaps_in = 5;
      gaps_out = 20;
      border_size = 2;
      resize_on_border = false;
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";
     };

     decoration = {
      rounding = 10;
      active_opacity = 1.0;
      inactive_opacity = 1.0;

      shadow = {
         enabled = true;
         range = 4;
         render_power = 3;
         color = "rgba(1a1a1aee)";
      };

      blur = {
         enabled = true;
         size = 3;
         passes = 1;
         vibrancy = 0.1696;
      };
     };

     master = {
      new_status = "master";
     };

     misc = {
      force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
      disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
     };

     device = {
      name = "epic-mouse-v1";
      sensitivity = -1;
     };
    };

    extraConfig = "
     monitor=DP-2, preferred, 0x0, auto
     monitor=DP-1, preferred, auto-right, auto
     monitor=HDMI-A-1, preferred, auto-left, auto
     workspace=1,monitor:DP-2
     workspace=2,monitor:HDMI-A-1
     workspace=3,monitor:DP-1
    ";
  };
}
