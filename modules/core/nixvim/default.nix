{ nixvim, pkgs, ... }: {
   imports = [
     nixvim.nixosModules.nixvim
     ./keymaps.nix
     ./plugins
     ./options.nix
   ];

   programs.nixvim = {
     enable = true;
     viAlias = true;
     vimAlias = true;
     defaultEditor = true;
     nixpkgs.source = pkgs.path;

     colorschemes.catppuccin.enable = true;
     plugins = {
     lualine.enable = true;
     oil.enable = true;
     };
   };
}
