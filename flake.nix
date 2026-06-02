{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yandex-music = {
      url = "github:cucumber-sp/yandex-music-linux";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pipewire-screenaudio = {
      url = "github:IceDBorn/pipewire-screenaudio";
      inputs.nixpkgs.follows = "nixpkgs";
    };
   };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      overlays = [ ];

      forAllSystems = f:
        nixpkgs.lib.genAttrs systems (system:
          f system (import nixpkgs { inherit system overlays; })
        );
    in {
      nixosConfigurations = {
        main = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = inputs;
          modules = [ ./hosts/main ];
        };
      };
    };
}
