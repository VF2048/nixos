# Игры: Steam и gamescope. Это NixOS-модули с SUID-обёртками и 32-битными
# библиотеками, поэтому в Home Manager они не переносятся.
{ pkgs, ... }: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;        # порты Steam Remote Play
    dedicatedServer.openFirewall = false;  # порты выделенных серверов закрыты
    gamescopeSession.enable = true;        # отдельная сессия gamescope из Steam
    extraCompatPackages = [ pkgs.proton-ge-bin ]; # Proton-GE для Windows-игр
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true; # разрешить повышать приоритет (меньше фризов)
    args = [
      "--rt"             # realtime-планирование
      "--expose-wayland" # дать играм доступ к Wayland-сокету gamescope
    ];
  };
}
