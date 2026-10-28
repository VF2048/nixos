{
  description = "NixOS configuration";

  # ---------------------------------------------------------------------------
  # Входы (inputs): откуда берутся пакеты и модули.
  # `inputs.nixpkgs.follows = "nixpkgs"` заставляет зависимость использовать
  # ТОТ ЖЕ nixpkgs, что и система — без второй копии в хранилище.
  # ---------------------------------------------------------------------------
  inputs = {
    # Основной репозиторий пакетов — стабильная ветка 26.05.
    nixpkgs.url = "github:NixOS/nixpkgs/release-26.05";

    # Telegram WebSocket-прокси (пакет и app экспортируются ниже в outputs).
    tg-ws-proxy.url = "github:pialtor/tg-ws-proxy-flake";

    # Обход блокировок Discord/YouTube. Раньше был локальный
    # "path:/home/vfok/zapret-discord-youtube" — он привязывал конфигурацию к
    # одной машине и ломал воспроизводимость. Теперь — репозиторий на GitHub.
    zapret-discord-youtube.url = "github:kartavkun/zapret-discord-youtube";

    opencode.url = "github:anomalyco/opencode/dev";

    # Home Manager — управление пользовательской конфигурацией.
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Nixvim — Neovim, настраиваемый через Nix.
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Stylix — единая цветовая тема по обоям.
    stylix = {
      url = "github:danth/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Захват звука отдельных приложений в Firefox (native messaging host).
    pipewire-screenaudio = {
      url = "github:IceDBorn/pipewire-screenaudio";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Caelestia — оболочка рабочего стола (панель, лаунчер, lock и т.д.).
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Удалены как неиспользуемые (на них нигде не было ссылок):
    #   superfile      — модуль programs.superfile есть в самом Home Manager;
    #   caelestia-cli  — CLI подтягивается самим caelestia-shell.
  };

  outputs = { nixpkgs, tg-ws-proxy, ... }@inputs:
    let
      # Все настраиваемые значения — в vars.nix.
      vars = import ./vars.nix;
      system = vars.host.system;
    in {
      # Пакет и приложение tg-ws-proxy: `nix run .#tg-ws-proxy` (бинд SUPER+T).
      packages.${system}.tg-ws-proxy = tg-ws-proxy.packages.${system}.default;
      apps.${system}.tg-ws-proxy = tg-ws-proxy.apps.${system}.default;

      nixosConfigurations.${vars.host.flakeName} = nixpkgs.lib.nixosSystem {
        inherit system;
        # Эти значения доступны аргументами во всех NixOS-модулях:
        #   inputs — все входы flake, vars — файл vars.nix.
        specialArgs = { inherit inputs vars; };
        modules = [ ./hosts/main ];
      };
    };
}
