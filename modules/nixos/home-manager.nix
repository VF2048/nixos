# Подключение Home Manager как модуля NixOS.
{ inputs, vars, ... }: {
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    # Использовать тот же pkgs, что и в системе (с allowUnfree и оверлеями).
    # Обязательно, иначе несвободные пакеты в Home Manager не соберутся.
    useGlobalPkgs = true;
    # Ставить пакеты пользователя в /etc/profiles/per-user/<имя>
    # (стандартный способ для NixOS-интеграции).
    useUserPackages = true;
    # Если файл, который собирается создать Home Manager, уже существует —
    # переименовать старый в *.backup вместо ошибки.
    backupFileExtension = "backup";
    # Передаём inputs и vars в КАЖДЫЙ модуль Home Manager.
    extraSpecialArgs = { inherit inputs vars; };

    # Основной пользователь: вся его конфигурация — в modules/home.
    users.${vars.user.name} = import ../home;
    # root: только stateVersion (минимум, чтобы Home Manager для него работал).
    users.root.home.stateVersion = vars.host.homeStateVersion;
  };
}
