# Локальный PostgreSQL (системная служба).
{ pkgs, vars, ... }: {
  services.postgresql = {
    enable = true;
    package = pkgs.${vars.postgres.package}; # версия — в vars.nix
    # Создать базу данных при первом запуске.
    ensureDatabases = [ vars.postgres.database ];
    # Создать роль; ensureDBOwnership делает её владельцем одноимённой БД
    # (имя роли и базы должны совпадать).
    ensureUsers = [
      {
        name = vars.postgres.role;
        ensureDBOwnership = true;
      }
    ];
  };
}
