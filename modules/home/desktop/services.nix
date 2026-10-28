# Пользовательские службы рабочего стола.
{ ... }: {
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
}
