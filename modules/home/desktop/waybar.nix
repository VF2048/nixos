# Waybar — панель задач (вариант "ddubs-2").
#
# ВНИМАНИЕ: программа включена (установлена и конфигурация записана), но
# автозапуск не настроен (systemd.enable не задан и в автостарте Hyprland её
# нет), а роль панели выполняет Caelestia. Если waybar не нужен вовсе, выключите
# vars.nix → features.waybar. Остальные варианты оформления лежат в archive/.
#
# Палитра ниже — base16-схема «Ayu»; значения заданы вручную, потому что
# Stylix-таргет waybar отключён (theme/stylix.nix).
{ pkgs, lib, vars, ... }:
let
  terminal = vars.apps.terminal; # терминал для кликов по модулям (запускает btop)
  # Цвета base16 (без #):
  base00 = "0F1419"; # фон
  base01 = "131721"; # светлее фона
  base03 = "3E4B59"; # комментарии
  base05 = "E6E1CF"; # основной текст
  base06 = "E6E1CF"; # основной текст (светлее)
  base07 = "F3F4F5"; # самый светлый
  base08 = "F07178"; # красный
  base09 = "FF8F40"; # оранжевый
  base0A = "FFB454"; # жёлтый
  base0B = "B8CC52"; # зелёный
  base0C = "95E6CB"; # бирюзовый
  base0D = "59C2FF"; # синий
  base0E = "D2A6FF"; # фиолетовый
  base0F = "E6B673"; # коричневый/золотой
in
with lib; {
  # Configure & Theme Waybar
  # Waybar: настройка и тема.
  programs.waybar = {
    enable = true;           # установить waybar и записать конфигурацию
    package = pkgs.waybar;   # пакет waybar из nixpkgs
    settings = [
      {
        layer = "top";      # поверх обычных окон
        position = "top";   # панель у верхнего края

        # Какие модули и в каком порядке показывать:
        modules-left = [ "custom/startmenu" "tray" "hyprland/window" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ "idle_inhibitor" "custom/notification" "pulseaudio" "battery" "clock" "custom/exit" ];

        # Рабочие столы Hyprland; колесо мыши переключает их.
        "hyprland/workspaces" = {
          format = "{name}";
          format-icons = {
            default = " ";
            active = " ";
            urgent = " ";
          };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };
        # Часы; во всплывающей подсказке — календарь.
        "clock" = {
          format = '' {:%H:%M}'';
          /*
            ''{: %I:%M %p}'';
            */
          tooltip = true;
          tooltip-format = "<big>{:%A, %d.%B %Y }</big><tt><small>{calendar}</small></tt>";
        };
        # Заголовок активного окна (не длиннее 60 символов).
        "hyprland/window" = {
          max-length = 60;
          separate-outputs = false;
        };
        # Использование ОЗУ; клик — btop в терминале (в modules-* не включён).
        "memory" = {
          interval = 5;
          format = " {}%";
          tooltip = true;
          on-click = "${terminal} -e btop";
        };
        # Загрузка процессора; клик — btop (не включён в modules-*).
        "cpu" = {
          interval = 5;
          format = " {usage:2}%";
          tooltip = true;
          on-click = "${terminal} -e btop";
        };
        # Свободное место на диске (не включён в modules-*).
        "disk" = {
          format = " {free}";
          tooltip = true;
          # Not working with zaneyos window open then closes
          #on-click = "${terminal} -e sh -c df -h ; read";
        };
        # Сеть: скорость загрузки, значки Wi-Fi (не включён в modules-*).
        "network" = {
          format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
          format-ethernet = " {bandwidthDownBits}";
          format-wifi = " {bandwidthDownBits}";
          format-disconnected = "󰤮";
          tooltip = false;
          on-click = "${terminal} -e btop";
        };
        # Системный трей (иконки приложений).
        "tray" = {
          spacing = 12;
        };
        # Громкость и микрофон; клик открывает pavucontrol.
        "pulseaudio" = {
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };
        # Кнопка выключения. ВНИМАНИЕ: вызывает wlogout, которого нет в системе.
        "custom/exit" = {
          tooltip = false;
          format = "⏻";
          on-click = "sleep 0.1 && wlogout";
        };
        # Кнопка меню приложений (rofi).
        "custom/startmenu" = {
          tooltip = false;
          format = " ";
          # exec = "rofi -show drun";
          on-click = "rofi -show drun";
        };
        # Переключатель «не засыпать».
        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = " ";
            deactivated = " ";
          };
          tooltip = "true";
        };
        # Индикатор уведомлений swaync (swaync в системе не установлен — модуль не активен).
        "custom/notification" = {
          tooltip = false;
          format = "{icon} {}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t";
          escape = true;
        };
        # Батарея (если батареи нет — модуль просто не отображается; оставлен из шаблона).
        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󱘖 {capacity}%";
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          on-click = "";
          tooltip = false;
        };
      }
    ];
    # Стили CSS панели (цвета подставляются из палитры base16 выше).
    style = concatStrings [
      ''
        * {
          font-size: 16px;
          font-family: JetBrainsMono Nerd Font, Font Awesome, sans-serif;
          font-weight: bold;
        }
        window#waybar {
          /*

            background-color: rgba(26,27,38,0);
            border-bottom: 1px solid rgba(26,27,38,0);
            border-radius: 0px;
            color: #${base0F};
          */

          background-color: rgba(26,27,38,0);
          border-bottom: 1px solid rgba(26,27,38,0);
          border-radius: 0px;
          color: #${base0F};
        }
        #workspaces {
          /*
            Eternal
            background: linear-gradient(180deg, #${base00}, #${base01});
            margin: 5px 5px 5px 0px;
            padding: 0px 10px;
            border-radius: 0px 15px 15px 0px;
            border: 0px;
            font-style: normal;
            color: #${base00};
          */
          background: linear-gradient(45deg, #${base01}, #${base01});
          margin: 5px;
          padding: 0px 1px;
          border-radius: 15px;
          border: 0px;
          font-style: normal;
          color: #${base00};
        }
        #workspaces button {
          padding: 0px 5px;
          margin: 4px 3px;
          border-radius: 15px;
          border: 0px;
          color: #${base00};
          background: linear-gradient(45deg, #${base0D}, #${base0E});
          opacity: 0.5;
          transition: all 0.3s ease-in-out;
        }
        #workspaces button.active {
          padding: 0px 5px;
          margin: 4px 3px;
          border-radius: 15px;
          border: 0px;
          color: #${base00};
          background: linear-gradient(45deg, #${base0D}, #${base0E});
          opacity: 1.0;
          min-width: 40px;
          transition: all 0.3s ease-in-out;
        }
        #workspaces button:hover {
          border-radius: 15px;
          color: #${base00};
          background: linear-gradient(45deg, #${base0D}, #${base0E});
          opacity: 0.8;
        }
        tooltip {
          background: #${base00};
          border: 1px solid #${base0E};
          border-radius: 10px;
        }
        tooltip label {
          color: #${base07};
        }
        #window {
          /*
            Eternal
            color: #${base05};
            background: #${base00};
            border-radius: 15px;
            margin: 5px;
            padding: 2px 20px;
          */
          margin: 5px;
          padding: 2px 20px;
          color: #${base05};
          background: #${base01};
          border-radius: 15px 15px 15px 15px;
        }
        #memory {
          color: #${base0F};
          /*
            Eternal
            background: #${base00};
            border-radius: 15px 15px 15px 15px;
            margin: 5px;
            padding: 2px 20px;
          */
          background: #${base01};
          margin: 5px;
          padding: 2px 20px;
          border-radius: 15px 15px 15px 15px;
        }
        #clock {
          color: #${base0B};
            background: #${base00};
            border-radius: 15px 15px 15px 15px;
            margin: 5px;
            padding: 2px 20px;
        }
        #idle_inhibitor {
          color: #${base0A};
            background: #${base00};
            border-radius: 15px 15px 15px 15px;
            margin: 3px;
            padding: 2px 20px;
        }
        #cpu {
          color: #${base07};
            background: #${base00};
            border-radius: 15px 15px 15px 15px;
            margin: 5px;
            padding: 2px 20px;
        }
        #disk {
          color: #${base0F};
            background: #${base00};
            border-radius: 15px 15px 15px 15px;
            margin: 5px;
            padding: 2px 20px;
        }
        #battery {
          color: #${base08};
          background: #${base00};
          border-radius: 15px 15px 15px 15px;
          margin: 5px;
          padding: 2px 20px;
        }
        #network {
          color: #${base09};
          background: #${base00};
          border-radius: 15px 15px 15px 15px;
          margin: 5px;
          padding: 2px 20px;
        }
        #tray {
          color: #${base05};
          background: #${base00};
          border-radius: 15px 15px 15px 15px;
          margin: 5px;
          padding: 2px 15px;
        }
        #pulseaudio {
          color: #${base0D};
          /*
            Eternal
            background: #${base00};
            border-radius: 15px 15px 15px 15px;
            margin: 5px;
            padding: 2px 20px;
          */
          background: #${base01};
          margin: 4px;
          padding: 2px 20px;
          border-radius: 15px 15px 15px 15px;
        }
        #custom-notification {
          color: #${base0C};
          background: #${base00};
          border-radius: 15px 15px 15px 15px;
          margin: 5px;
          padding: 2px 20px;
        }
        #custom-startmenu {
          color: #${base0E};
          background: #${base00};
          border-radius: 0px 15px 15px 0px;
          margin: 5px 5px 5px 0px;
          padding: 2px 20px;
        }
        #idle_inhibitor {
          color: #${base09};
          background: #${base00};
          border-radius: 15px 15px 15px 15px;
          margin: 5px;
          padding: 2px 20px;
        }
        #custom-exit {
          color: #${base0E};
          background: #${base00};
          border-radius: 15px 0px 0px 15px;
          margin: 5px 0px 5px 5px;
          padding: 2px 20px;
        }
      ''
    ];
  };
}
