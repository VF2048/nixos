{ config, pkgs, ... }:

let
  # 1. Создаем пропатченную версию appimage-run со всеми библиотеками
  hiddify-runner = pkgs.appimage-run.override {
    extraPkgs = pkgs: with pkgs; [ 
      libepoxy 
      webkitgtk_4_1 
      zstd 
      stdenv.cc.cc.lib 
      libx11 
    ];
  };

  # 2. Создаем системный ярлык для меню приложений
  hiddify-desktop = pkgs.makeDesktopItem {
    name = "hiddify";
    desktopName = "Hiddify";
    genericName = "VPN Client";
    comment = "Universal proxy client based on sing-box";
    # Путь к вашему AppImage файлу
    exec = "${hiddify-runner}/bin/appimage-run /home/vfok/Downloads/Hiddify-Linux-x64-AppImage.AppImage";
    icon = "hiddify"; # Имя иконки (можно положить в ~/.local/share/icons/hiddify.png)
    terminal = false;
    categories = [ "Network" "Utility" ];
    keywords = [ "vpn" "proxy" "sing-box" ];
  };
in
{
  environment.systemPackages = with pkgs; [
    hiddify-runner    # Сама утилита запуска
    hiddify-desktop   # Ярлык для меню приложений
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      libepoxy
      webkitgtk_4_1
      zstd
      stdenv.cc.cc.lib
      libx11
      gtk3
      glib
    ];
  };
}
