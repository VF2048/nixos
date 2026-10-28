# Системный слой NixOS.
#
# Сюда попало ТОЛЬКО то, что нельзя настроить из Home Manager: загрузчик,
# драйверы, системные службы (root), PAM/polkit, пользователи, firewall,
# регистрация сессии Hyprland, SUID-обёртки Steam. Всё остальное —
# в modules/home/.
#
# Необязательные модули подключаются по флагам из vars.nix → features.
{ vars, ... }:
let
  f = vars.features;
  # Вспомогательная функция: [ модуль ] если флаг включён, иначе [ ].
  when = cond: module: if cond then [ module ] else [ ];
in
{
  imports =
    [
      ./base.nix            # nix, nixpkgs, stateVersion
      ./boot.nix            # загрузчик, модуль ядра tun
      ./hardware.nix        # NVIDIA, bluetooth, logitech
      ./locale.nix          # часовой пояс и локали
      ./users.nix           # пользователь, оболочка fish
      ./network.nix         # имя хоста и firewall
      ./security.nix        # polkit, rtkit, PAM, keyring
      ./audio.nix           # PipeWire
      ./desktop.nix         # Hyprland-сессия, порталы, службы рабочего стола
      ./greeter.nix         # greetd + tuigreet
      ./nix-ld.nix          # запуск сторонних бинарников
      ./packages.nix        # пакеты, которые должны быть у root
      ./home-manager.nix    # подключение Home Manager
    ]
    ++ when f.steam ./gaming.nix
    ++ when f.docker ./virtualisation.nix
    ++ when f.postgresql ./database.nix
    ++ when f.zapret ./zapret.nix;
}
