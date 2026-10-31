# Терминал kitty.
{ vars, ... }: {
  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;            # не спрашивать подтверждение при закрытии окна
      font_size = vars.apps.terminalFontSize; # размер шрифта (vars.nix)
    };
    # Пробрасываем + и - в программу как обычный текст, чтобы btop
    # получал их напрямую, а не в виде kitty keyboard protocol.
    keybindings = {
      "equal" = "send_text all +";
      "shift+equal" = "send_text all +";
      "minus" = "send_text all -";
      "kp_add" = "send_text all +";
      "kp_subtract" = "send_text all -";
    };
  };
}
