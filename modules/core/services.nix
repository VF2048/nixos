{ ... }:{
  services = {
    gnome.gnome-keyring.enable = true;
    power-profiles-daemon.enable = true;
    
    # Enable the OpenSSH daemon.
    openssh.enable = true;
    
    # Enable the X11 windowing system.
    xserver.enable = true;
    
    # Enable the GNOME Desktop Environment.
    #xserver.displayManager.gdm.enable = true;
    #desktopManager.gnome.enable = false;
    xserver.displayManager.lightdm.enable = false;

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable sound with pipewire.
    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
      extraConfig.pipewire."10-clock" = {
        "context.properies" = {
          "default.clock.rate" = 48000;
          "default.clock.allowed-rates" = [ 48000 ];
          "default.clock.quantum" = 1024;
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 8192;
        };
      };
    };
    # Enable touchpad support (enabled default in most desktopManager).
    # xserver.libinput.enable = true;

    # Load nvidia driver for Xorg and Wayland
    xserver.videoDrivers = [ "nvidia" ];

    blueman.enable = true;

    ollama = {
      enable = true;
      environmentVariables = {
        OLLAMA_HOST = "0.0.0.0:11434";
      };
      # host = "127.0.0.1"; # Optional: restrict bind address
      # port = 11434;       # Default port
    };
  };
}
