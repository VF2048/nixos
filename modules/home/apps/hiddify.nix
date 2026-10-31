# Hiddify — универсальный VPN/прокси-клиент на базе sing-box.
# Берётся AppImage с GitHub и оборачивается в FHS-окружение (bubblewrap),
# поэтому отдельные системные библиотеки для него не нужны.
# Версия и хэш — в vars.nix → hiddify. (Модуль TUN для ядра — modules/nixos/boot.nix.)
{ pkgs, vars, ... }:
let
  version = vars.hiddify.version;

  hiddify-pkg = pkgs.appimageTools.wrapType2 {
    pname = "hiddify";
    inherit version;

    # Nix скачивает AppImage напрямую из релизов GitHub.
    src = pkgs.fetchurl {
      url = "https://github.com/hiddify/hiddify-app/releases/download/v${version}/Hiddify-Linux-x64-AppImage.AppImage";
      # При смене версии: поставьте hash = ""; Nix покажет правильный в `got:`.
      hash = vars.hiddify.hash;
    };

    # Библиотеки, доступные приложению внутри FHS-окружения.
    extraPkgs = pkgs: with pkgs; [
      libepoxy
      webkitgtk_4_1
      zstd
      stdenv.cc.cc.lib
      libx11
      gtk3
      glib
      libunwind
    ];
  };

  # Ярлык для меню приложений.
  hiddify-desktop = pkgs.makeDesktopItem {
    name = "hiddify";
    desktopName = "Hiddify";
    genericName = "VPN Client";
    comment = "Universal proxy client based on sing-box";
    exec = "${hiddify-pkg}/bin/hiddify";
    icon = "hiddify";
    terminal = false;
    categories = [ "Network" "Utility" ];
    keywords = [ "vpn" "proxy" "sing-box" ];
  };

  # Иконка лежит внутри AppImage, а в системе с таким именем её нет.
  # Извлекаем её и кладём в hicolor, чтобы Caelestia и другие оболочки нашли `hiddify`.
  hiddify-icons = pkgs.runCommand "hiddify-icons" { } ''
    mkdir -p $out/share/icons/hicolor
    cp -r ${(pkgs.appimageTools.extractType2 {
      pname = "hiddify";
      inherit version;
      src = pkgs.fetchurl {
        url = "https://github.com/hiddify/hiddify-app/releases/download/v${version}/Hiddify-Linux-x64-AppImage.AppImage";
        hash = vars.hiddify.hash;
      };
    })}/usr/share/icons/hicolor/. $out/share/icons/hicolor/
  '';
in
{
  home.packages = [ hiddify-pkg hiddify-desktop hiddify-icons ];
}
