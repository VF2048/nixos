{ ... }: {
  imports = [
   ../../modules/core/tuigreet.nix
   ./variables.nix
   ./home-manager.nix
   ../services/zapret.nix
   ../services/ollama.nix
   ../../modules/core
   ./configuration.nix
   ./hardware-configuration.nix
  ];
}