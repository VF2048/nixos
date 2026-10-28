# nix-ld: позволяет запускать обычные (не-Nix) бинарники, которые ждут
# библиотеки по стандартным путям (загруженные программы, wheel-пакеты pip,
# LSP-серверы и т.д.). Это настройка уровня системы (создаёт /lib64/ld-linux).
{ pkgs, ... }: {
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
