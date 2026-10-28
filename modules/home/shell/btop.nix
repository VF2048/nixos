# btop — монитор ресурсов.
{ pkgs, ... }: {
  programs.btop = {
    enable = true;
    # Сборка с поддержкой мониторинга GPU.
    # ВНИМАНИЕ: у вас видеокарта NVIDIA и процессор AMD, поэтому rocmSupport
    # (стек AMD GPU) бесполезен и заставляет тянуть лишнее; можно поставить false.
    package = pkgs.btop.override {
      rocmSupport = true;
      cudaSupport = true;
    };
    settings = {
      vim_keys = true;           # навигация клавишами h/j/k/l
      rounded_corners = true;    # скруглённые углы рамок
      proc_tree = true;          # процессы деревом
      show_gpu_info = "on";      # показывать блок GPU
      show_uptime = true;        # время работы системы
      show_coretemp = true;      # температура ядер CPU
      cpu_sensor = "auto";       # датчик температуры CPU выбирается автоматически
      show_disks = true;         # блок дисков
      only_physical = true;      # только физические диски (без tmpfs и т.п.)
      io_mode = true;            # показывать операции ввода-вывода
      io_graph_combined = true;  # общий график чтения/записи
    };
  };
}
