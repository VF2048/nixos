# Конфигурация пользователя (Home Manager).
# Подключается из modules/nixos/home-manager.nix для пользователя vars.user.name.
# Аргументы `inputs` и `vars` приходят из home-manager.extraSpecialArgs.
{ inputs, vars, ... }:
let
  f = vars.features;
  when = cond: module: if cond then [ module ] else [ ];

  opencodeNodeModules =
    inputs.opencode.packages.${vars.host.system}.node_modules_updater.override {
      hash = "sha256-I3JJjXdMbFpG+6gmecbFpPA67b6pdGey0tTmV3ciE0c=";
    };

  opencodePackage =
    inputs.opencode.packages.${vars.host.system}.opencode.override {
      node_modules = opencodeNodeModules;
    };
in
{
  imports =
    [
      # --- Внешние модули Home Manager (из flake inputs) ---
      inputs.caelestia-shell.homeManagerModules.default # programs.caelestia
      inputs.stylix.homeModules.stylix                  # stylix.*
      inputs.nixvim.homeModules.nixvim                  # programs.nixvim

      # --- Общее ---
      ./session.nix          # переменные окружения, XDG
      ./packages.nix         # пакеты пользователя

      # --- Тема ---
      ./theme/stylix.nix     # палитра по обоям (включается флагом)
      ./theme/cursor.nix     # курсор мыши
      ./theme/fonts.nix      # шрифты
      ./theme/gtk-qt.nix     # иконки GTK/Qt

      # --- Командная строка ---
      ./shell/fish.nix
      ./shell/direnv.nix
      ./shell/kitty.nix
      ./shell/btop.nix
      ./shell/superfile.nix

      # --- Редактор ---
      ./editor/nixvim

      # --- Приложения ---
      ./apps/firefox.nix
      ./apps/kdeconnect.nix
      ./apps/launcher.nix    # wofi

      # --- Рабочий стол ---
      ./desktop/hyprland
      ./desktop/caelestia.nix
      ./desktop/services.nix # cliphist, gnome-keyring
    ]
    ++ when f.hiddify ./apps/hiddify.nix
    ++ when f.hyprlock ./desktop/hyprlock.nix
    ++ when f.waybar ./desktop/waybar.nix;


    home.packages = [
    opencodePackage
  ];
  # Версия, с которой создавалось состояние Home Manager. НЕ ПОВЫШАТЬ при обновлении.
  home.stateVersion = vars.host.homeStateVersion;

  # Home Manager управляет собственным корректным запуском XDG-каталогов.
  # (Имя и домашний каталог пользователя задаёт NixOS-интеграция автоматически.)
}
