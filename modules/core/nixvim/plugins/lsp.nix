{ pkgs, ... }: {
  # For wgsl_analyzer
  # environment.sessionVariables.PATH = [
  #   "/home/user/.cargo/bin/"
  # ];

  programs.nixvim = {
    plugins.lsp = {
      enable = true;
      keymaps = {
        lspBuf = {
          "gd" = "definition";
          "gr" = "references";
          # "gt" = "type_definition";
          "gi" = "implementation";
          "<leader>a" = "code_action";
          "<leader>r" = "rename";
          # "<leader>i" = "incoming_calls";
          # "<leader>o" = "outgoing_calls";
          "<leader>i" = "hover";
        };
      };
      servers = {
        nixd = {
          enable = true;
          settings = {
            nixpkgs.expr = "import <nixpkgs> {}";
            # options = {
            #   nixos.expr = ''(builtins.getFlake "/home/user/flakes/system").nixosConfigurations.local.options'';
            #   nixvim.expr = ''(import (builtins.fetchGit "https://github.com/nix-community/nixvim")).packages.x86_64-linux.options-json.options'';
            # };
          };
        };
        clangd.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
          settings = {
            cargo = {
              features = "all";
              targetDir = "target_rust_analyzer";
            };
          };
        };
        wgsl_analyzer = {
          enable = true;
        };
        # java_language_server.enable = true;
        # cmake.enable = true;
        # lua_ls.enable = true;
      };
    };
  };
}
