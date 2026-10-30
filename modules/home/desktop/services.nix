# Пользовательские службы рабочего стола.
{ pkgs, ... }: {
  # История буфера обмена (используется Caelestia: SUPER+C).
  services.cliphist = {
    enable = true;
    allowImages = true; # сохранять в истории и изображения
  };

  # Связка ключей GNOME Keyring: пароли приложений (Secret Service) и ключи PKCS#11.
  # Раньше запускалась самописной systemd-службой; теперь — штатным модулем.
  # Серверная часть и PAM-разблокировка — в modules/nixos/security.nix.
  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" "pkcs11" ];
  };

  # Локальный OpenAI-compatible endpoint, использующий OAuth-сессию Codex.
  # Сервис стартует в фоне при запуске пользовательского systemd-manager.
  systemd.user.services.openai-oauth = {
    Unit.Description = "OpenAI OAuth local API proxy";
    Service = {
      ExecStart = "${pkgs.nodejs}/bin/npx --yes openai-oauth";
      Environment = "PATH=${pkgs.nodejs}/bin";
      Restart = "on-failure";
      RestartSec = "5s";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
