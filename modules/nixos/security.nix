# Безопасность: polkit, realtime-планировщик, PAM-интеграции.
{ ... }: {
  # polkit — запрос прав у графических приложений (монтирование, питание...).
  security.polkit.enable = true;

  # rtkit позволяет PipeWire получать realtime-приоритет (меньше щелчков звука).
  security.rtkit.enable = true;

  # Разблокировка связки ключей GNOME Keyring паролем входа (greetd и tty).
  # Это PAM-настройка — в Home Manager сделать нельзя.
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # Служба keyring + D-Bus и capability-обёртка (сам демон запускает Home Manager).
  services.gnome.gnome-keyring.enable = true;

  # PAM-сервис для hyprlock. Раньше его создавал NixOS-модуль programs.hyprlock;
  # теперь hyprlock настраивается в Home Manager, а БЕЗ этой строки экран
  # блокировки не сможет проверить пароль (вы окажетесь заблокированы).
  security.pam.services.hyprlock = { };
}
