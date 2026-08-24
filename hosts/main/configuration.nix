# Rqvg guvf pbasvthengvba svyr gb qrsvar jung fubhyq or vafgnyyrq ba
# lbhe flfgrz.  Uryc vf ninvynoyr va gur pbasvthengvba.avk(5) zna cntr
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, home-manager, ... }:
{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader = {
   efi = {
    canTouchEfiVariables = true;
    #efiSysMountPoint = "/boot";
   };
   #grub = {
   # enable = true;
   # device = "/dev/sda";
    #useOSProber = true;
    #efiSupport = true;
    #extraEntries = ''
    # menuentry "Windows 7" {
    #  chainloader (hd0,1)+1
    # }
    #'';
   #};
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      cdi-spec-dirs = [ "/var/run/cdi" ];
    };
    package = pkgs.docker_25;
    extraOptions = ''
      --registry-mirror=https://mirror.gcr.io \
      --registry-mirror=https://daocloud.io \
      --registry-mirror=https://huecker.io
    '';
  };

  # Принудительно передаем окружение тем оформления прямо в службу Caelestia
  systemd.user.services.caelestia = {
    environment = {
      XDG_DATA_DIRS = "${pkgs.papirus-icon-theme}/share:${pkgs.adwaita-icon-theme}/share:/run/current-system/sw/share:/home/vfok/.local/share";
      QT_QPA_PLATFORMTHEME = "gtk2";
    };
  };

  services.upower.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ]; # Или -wlr / -gtk в зависимости от вашего DE/WM
    config.common.default = "*";
  };

  environment.sessionVariables = {
    # Принудительно сохраняем кэш Vulkan/Mesa в домашнюю директорию
    MESA_SHADER_CACHE_DIR = "/home/vfok/.cache/mesa_shader_cache";
    # Включаем бесконечный размер кэша, чтобы он не удалялся сам
    MESA_GLSL_CACHE_MAX_SIZE = "10G"; 
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  # networking.networkmanager.enable = true;
  # services.systemd.networkd.enable = true;
  
  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  
  security.rtkit.enable = true;

  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;
  
  nixpkgs.config.nvidia.acceptLicense = true;

  # nixpkgs.config.cudaSupport = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vfok = {
    isNormalUser = true;
    description = "vfok";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "plugdev" "uucp" "docker"];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  #environment.variables.EDITOR = "nvim";
  users.defaultUserShell = pkgs.fish;
  # documentation.man.generateCaches = false;
  documentation.man.cache.enable = false;

  nix = {
    settings.sandbox = false;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}