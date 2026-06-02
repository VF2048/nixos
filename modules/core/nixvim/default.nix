{ nixvim, ... }: {
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

     colorschemes.catppuccin.enable = true;
     plugins = {
     lualine.enable = true;
     oil.enable = true;
     };
   };
}
