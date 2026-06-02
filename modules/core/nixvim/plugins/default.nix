{
  imports = [
   ./treesitter.nix
   ./telescope.nix
   ./lsp.nix
  ];

  programs.nixvim = {
    plugins = {
      web-devicons.enable = true;
    };
  };
}
