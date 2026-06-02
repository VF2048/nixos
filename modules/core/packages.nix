{pkgs, pipewire-screenaudio, ... }:{

  programs = {
   hyprland = {
     enable = true;
     xwayland.enable = true;
   };
   hyprlock.enable = true;
   fish.enable = true;
   firefox.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
   wofi
   git
   chromium
   remmina
   pavucontrol
   ripgrep
   ethtool
   nmap
   (firefox.override { nativeMessagingHosts = [ pipewire-screenaudio.packages.${pkgs.system}.default ]; })
   # wineWowPackages.waylandFull
   # winetricks
   # freerdp
   # rdesktop
  ];
}
