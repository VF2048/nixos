# Звук: PipeWire.
{ vars, ... }: {
  # Старый PulseAudio отключён — его заменяет pipewire-pulse.
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;          # поддержка ALSA-приложений
    alsa.support32Bit = true;    # 32-битные ALSA-клиенты (нужны Wine/Steam)
    pulse.enable = true;         # совместимость с PulseAudio-клиентами
    # jack.enable = true;        # раскомментируйте для JACK-приложений

    # Фиксированная частота и размеры буфера (значения — в vars.nix → audio).
    extraConfig.pipewire."10-clock" = {
      # ИСПРАВЛЕНО: раньше было "context.properies" (опечатка), и весь блок
      # молча игнорировался.
      "context.properties" = {
        "default.clock.rate" = vars.audio.sampleRate;
        "default.clock.allowed-rates" = [ vars.audio.sampleRate ];
        "default.clock.quantum" = vars.audio.quantum;
        "default.clock.min-quantum" = vars.audio.minQuantum;
        "default.clock.max-quantum" = vars.audio.maxQuantum;
      };
    };
  };
}
