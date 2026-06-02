{ stylix, yandex-music, ... }:{
  imports = [
   #./greetd.nix
   ./sddm.nix
   ./packages.nix
   ./stylix.nix
   ./nixvim
   ./steam.nix
   ./services.nix
   stylix.nixosModules.stylix
   yandex-music.nixosModules.default
   ./yandex-music.nix
  ];
}
