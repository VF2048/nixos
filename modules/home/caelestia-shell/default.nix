{ pkgs, inputs, ... }: {

  programs.caelestia = {
    enable = true;
    cli = {
      enable = true;
    };
    settings = {
      general = {
        idle = {
          lockBeforeSleep = true;
          inhibitWhenAudio = true;
          timeouts = [
            {
              timeout = 1800;
              idleAction = "lock";
            }
            {
              timeout = 7200;
              idleAction = "systemctl suspend";
            }
          ];
        };
      };
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/jpeg" = [ "caelestia.desktop" ];
      "image/png" = [ "caelestia.desktop" ];
      "image/gif" = [ "caelestia.desktop" ];
      "image/webp" = [ "caelestia.desktop" ];
      "image/bmp" = [ "caelestia.desktop" ];
    };
  };
}