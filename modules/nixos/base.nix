# Базовые настройки Nix и nixpkgs.
{ vars, ... }: {
  # Разрешаем несвободные пакеты (steam, discord, spotify, vscode, NVIDIA ...).
  # Благодаря home-manager.useGlobalPkgs = true этот же nixpkgs используется
  # и в Home Manager, поэтому отдельно разрешать unfree там не нужно.
  nixpkgs.config.allowUnfree = true;
  # Принимаем лицензию NVIDIA (нужна для CUDA/драйвера).
  nixpkgs.config.nvidia.acceptLicense = true;
  # nixpkgs.config.cudaSupport = true;  # глобальная сборка всего с CUDA (очень долго)

  nix.settings = {
    # Включаем новые команды `nix ...` и поддержку flakes.
    experimental-features = [ "nix-command" "flakes" ];
  };

  # Не собирать кэш man-страниц (ускоряет `nixos-rebuild`).
  documentation.man.cache.enable = false;

  # Версия, с которой создавалось состояние системы. НЕ ПОВЫШАТЬ при обновлении.
  system.stateVersion = vars.host.stateVersion;
}
