{ ... }: {
  imports = [
    ./programs.nix
    ./hyprland
    #  ./stylix.nix
    ./kitty.nix
    ./btop.nix
    ./fish.nix
    ./caelestia-shell
    ./services.nix
    #./waybar/waybar-curved.nix
    #./waybar/Jerry-waybar.nix
    #./waybar/waybar-simple.nix
    #./waybar/waybar-nekodyke.nix
    #./waybar/waybar-ddubs.nix
    ./waybar/waybar-ddubs-2.nix
  ];
}
