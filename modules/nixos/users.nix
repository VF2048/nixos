# Пользователь и оболочка по умолчанию.
{ pkgs, vars, ... }: {
  users.users.${vars.user.name} = {
    isNormalUser = true;                     # обычный пользователь (с домашним каталогом)
    description = vars.user.description;
    extraGroups = vars.user.extraGroups;     # sudo, docker, звук и т.д. — см. vars.nix
  };

  # fish — оболочка по умолчанию для всех пользователей (включая root).
  # programs.fish.enable на системном уровне нужен, чтобы fish попал в
  # /etc/shells и мог быть login-оболочкой; сама настройка fish — в Home Manager.
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;
}
