{ pkgs, ... }: {
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;
        nixvimInjections = true;
        folding.enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          nix       
          bash      
          markdown 
          json
          cpp
          javascript
        ];
        settings = {
	        auto_install = false;
          highlight.enable = true;
          indent.enable = true;
        };
      };
      # hmts.enable = true;
    };
  };
}
