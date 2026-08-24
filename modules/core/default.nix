{ stylix, yandex-music, ... }:{
  imports = [
   #./greetd.nix
   #./sddm.nix
   ./packages.nix
   ./stylix.nix
   ./nixvim
   ./steam.nix
   ./services.nix
   ./programs.nix
   ./hiddify.nix
   stylix.nixosModules.stylix
  ];
}
