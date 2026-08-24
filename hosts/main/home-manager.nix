{ inputs, pkgs, lib, home-manager, ... }:{
  imports =
  [ # Include the results of the hardware scan.
    (import "${home-manager}/nixos")
  ];
  
  home-manager = {
   users.vfok = {
    imports = [
     ../../modules/home
     inputs.caelestia-shell.homeManagerModules.default
    ];
    home.stateVersion = "25.05";
    xdg.enable = true;
    gtk = {
      enable = true;
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "*"; # Позволяет порталам корректно выбирать бэкенд
    };
    xdg.configFile."qt6ct/qt6ct.conf".source =
      lib.mkForce ((pkgs.formats.ini {}).generate "qt6ct-config" {
        Appearance = {
          icon_theme = "Papirus";
        };
      });
    };
   users.root.home.stateVersion = "25.05";
   backupFileExtension = "backup";
  };
}