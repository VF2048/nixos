# Шрифты. ИМЕНА — в vars.nix → theme.fonts; здесь — соответствующие ПАКЕТЫ.
# (Раньше пакеты шрифтов приходили только через Stylix, который был выключен,
# поэтому шрифты фактически не были установлены.)
{ pkgs, ... }: {
  # Разрешает Home Manager устанавливать шрифты и обновлять кэш fontconfig.
  fonts.fontconfig.enable = true;

  home.packages = [
    pkgs.nerd-fonts.jetbrains-mono # моноширинный шрифт с иконками (терминал, waybar)
    pkgs.montserrat                # шрифт интерфейса (sans-serif и serif)
  ];
}
