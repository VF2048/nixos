# Firefox с поддержкой захвата звука отдельных приложений (pipewire-screenaudio).
# Ставится как обычный пакет, а НЕ через programs.firefox: модуль Home Manager
# при stateVersion 26.05 может сменить каталог профиля, и браузер «потеряет»
# существующий профиль. Через override реализована та же логика, что была раньше.
{ pkgs, inputs, ... }: {
  home.packages = [
    (pkgs.firefox.override {
      # Native messaging host: связывает расширение браузера с PipeWire.
      nativeMessagingHosts = [
        inputs.pipewire-screenaudio.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    })
  ];
}
