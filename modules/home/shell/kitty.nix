# Терминал kitty.
{ vars, ... }: {
  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;            # не спрашивать подтверждение при закрытии окна
      font_size = vars.apps.terminalFontSize; # размер шрифта (vars.nix)
    };
  };
}
