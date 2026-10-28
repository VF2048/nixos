# Командная оболочка fish. (Системная часть — users.nix: fish как login-shell.)
{ ... }: {
  programs.fish = {
    enable = true;

    # Алиасы — замена ls/tree на eza (пакет eza — в packages.nix).
    shellAliases = {
      ls = "eza --icons=always --group-directories-first";            # список с иконками, каталоги первыми
      ll = "eza -lah --icons=always --git --group-directories-first"; # подробный список со статусом git
      tree = "eza --tree --icons=always";                             # дерево каталогов
    };

    # Ручной `direnv hook fish | source` больше не нужен: хук добавляет
    # programs.direnv (см. shell/direnv.nix).
  };
}
