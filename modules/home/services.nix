{ pkgs, ... }: {
  systemd.user.services.gnome-keyring-daemon = {
    Unit = {
      Description = "Start GNOME Keyring daemon";
      # Служба запустится только после того, как поднимется графическая сессия Wayland
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --foreground --components=secrets,pkcs11";
      Restart = "on-failure"; # Если служба упадет, systemd её поднимет
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
  services.cliphist = {
    enable = true;
    allowImages = true; # разрешить сохранение картинок, если нужно
  };
}