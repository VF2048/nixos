# NixOS + Home Manager (flake)

```
flake.nix                    входы и сборка конфигурации «main»
vars.nix                     ВСЕ настраиваемые значения (пользователь, мониторы, тема, порты, флаги функций)
hosts/main/                  конкретная машина
  default.nix                  список импортов
  hardware-configuration.nix   только сгенерированное (диски, ядро)
modules/nixos/               системный слой — то, что нельзя сделать из Home Manager
  base · boot · hardware · locale · users · network · security · audio
  desktop · greeter · nix-ld · packages · home-manager
  gaming · virtualisation · database · zapret      (включаются флагами vars.features)
modules/home/                пользовательский слой (Home Manager)
  session · packages
  theme/    stylix · cursor · fonts · gtk-qt
  shell/    fish · direnv · kitty · btop · superfile
  editor/   nixvim/ (+ plugins/)
  apps/     firefox · kdeconnect · launcher · hiddify
  desktop/  hyprland/ · caelestia · hyprlock · services · waybar
wallpapers/                  обои
archive/                     неподключённые файлы (см. archive/README.md)
```

## Команды

```bash
sudo nixos-rebuild switch --flake .#main     # применить
nix flake update                             # обновить входы
nix flake check                              # проверить конфигурацию
```

## Где менять что

- Имя пользователя, мониторы, раскладка, тема, порты, версии — **vars.nix**.
- Включить/выключить функцию — `vars.nix → features`.
- Новый пакет пользователя — `modules/home/packages.nix`.
- Системная служба — соответствующий файл в `modules/nixos/`.
