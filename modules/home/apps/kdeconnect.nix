# KDE Connect — связь с телефоном (уведомления, буфер обмена, файлы).
# Здесь запускается только служба; открытие портов 1714–1764 — в
# modules/nixos/network.nix (firewall — настройка системного уровня).
{ ... }: {
  services.kdeconnect.enable = true;
}
