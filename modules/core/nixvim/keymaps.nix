{ lib, ... }:{
  programs.nixvim = {
   keymaps = let
    normal =
        lib.mapAttrsToList (key: action: {
          mode = "n";
          inherit action key;
        }) {
          "<C-Backspace>" = ":Oil .<CR>";
	        "<Backspace>" = ":Oil<CR>";

          "<C-s>" = ":w<CR>";
          
          
          "<leader>ff" = ":Telescope find_files<CR>";
          "<leader>fl" = ":Telescope live_grep<CR>";
          "<leader>fb" = ":Telescope buffers<CR>";
          "<leader>fd" = ":Telescope diagnostics<CR>";
          "<leader>cd" = ":Cd<CR>:te<CR>:f term_root<CR>";
	};
    in
     (normal);
  };
}
