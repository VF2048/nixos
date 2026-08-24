{ pkgs, ... }:{
    programs = {
      wofi = {
        enable = true;
        settings = {
          allow_images = true;
          image_size = 48; # Размер значков в пикселях
          mode = "drun";
        };
      };
    };
}