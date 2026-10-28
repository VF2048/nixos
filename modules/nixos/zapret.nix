# zapret — обход DPI-блокировок Discord/YouTube.
# Работает как системная служба с правами root (nfqws + правила netfilter),
# поэтому настраивается на уровне NixOS. Параметры — в vars.nix → zapret.
{ inputs, vars, ... }: {
  imports = [
    # withTestTools добавляет утилиту `sudo zapret-test-strategies` для
    # перебора стратегий. Без неё можно использовать nixosModules.default.
    inputs.zapret-discord-youtube.nixosModules.withTestTools
  ];

  services.zapret-discord-youtube = {
    enable = true;
    configName = vars.zapret.configName;   # стратегия обхода
    gameFilter = vars.zapret.gameFilter;   # обработка игровых портов
    listGeneral = vars.zapret.listGeneral; # свои домены для обхода
    listExclude = vars.zapret.listExclude; # домены-исключения
  };
}
