{ pkgs, ... }:{
    programs = {

      hyprland = {
        enable = true;
        xwayland.enable = true;
        withUWSM = true;
      };
      hyprlock.enable = true;
      fish.enable = true;
      firefox.enable = true;
    };
}