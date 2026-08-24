{pkgs, pipewire-screenaudio, ... }:{
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wofi
    rofi
    git
    remmina
    pavucontrol
    ripgrep
    ethtool
    nmap
    (firefox.override { nativeMessagingHosts = [ pipewire-screenaudio.packages.${pkgs.stdenv.hostPlatform.system}.default ]; })
    vscode
    nftables
    spotify
    discord
    telegram-desktop
    solaar
    papirus-icon-theme
    adwaita-icon-theme
    qt6Packages.qt6ct
    libsForQt5.qt5ct
    thunar
    pinta
  ];
}
