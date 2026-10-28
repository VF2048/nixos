# Docker. Демон работает от root — только системный уровень.
{ pkgs, lib, vars, ... }: {
  virtualisation.docker = {
    enable = true;
    # Версия docker из vars.nix (docker_25 — EOL, см. комментарий там).
    package = pkgs.${vars.docker.package};
    daemon.settings = {
      # Каталоги CDI-спецификаций: через них контейнеры получают GPU.
      cdi-spec-dirs = vars.docker.cdiSpecDirs;
    };
    # Зеркала реестра: получается строка из нескольких --registry-mirror=...
    extraOptions = lib.concatMapStringsSep " \\\n"
      (mirror: "--registry-mirror=${mirror}") vars.docker.registryMirrors;
  };

  # Доступ к видеокарте NVIDIA из контейнеров (docker run --device nvidia.com/gpu=all).
  hardware.nvidia-container-toolkit.enable = true;
}
