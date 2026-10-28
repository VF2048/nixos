# Системные пакеты. Намеренно почти пусто: всё остальное — в Home Manager
# (modules/home/packages.nix).
{ pkgs, ... }: {
  environment.systemPackages = [
    # git должен быть у root: `sudo nixos-rebuild --flake .` запускается с
    # PATH системы, а не пользователя, и flake в git-репозитории требует git.
    pkgs.git
  ];
}
