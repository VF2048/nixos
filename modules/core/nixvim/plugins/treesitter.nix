{ pkgs, ... }: {
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;

        nixvimInjections = true;
	grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;

        folding = true;
        settings = {
	  auto_install = true;
          highlight.enable = true;
          indent.enable = true;
        };
      };
      hmts.enable = true;
    };
  };
}
