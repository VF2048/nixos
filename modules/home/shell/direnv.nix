# direnv: автоматическая загрузка окружения из .envrc / flake.nix при входе в каталог.
# Заменяет прежний ручной хук в fish.nix и системный bash.nix.
{ ... }: {
  programs.direnv = {
    enable = true;
    # nix-direnv: быстрая загрузка `use flake` с кэшированием окружения.
    # (Раньше пакет nix-direnv был лишь установлен, но не подключён.)
    nix-direnv.enable = true;
  };

  # Включаем bash в Home Manager, чтобы direnv работал и в bash
  # (раньше хук для bash задавал системный модуль bash.nix).
  # Если при активации появится ошибка из-за существующего ~/.bashrc.backup —
  # удалите этот файл.
  programs.bash.enable = true;
}
