# Имя хоста и firewall.
{ vars, ... }: {
  networking.hostName = vars.host.hostName;

  networking.firewall = {
    enable = true;
    # "loose" — без этого маршрутизация через TUN (VPN) часто ломается из-за
    # проверки обратного пути (rp_filter).
    checkReversePath = "loose";
    # SSH. openssh и так открывает порт сам (openFirewall = true по умолчанию),
    # поэтому строка дублирует его — оставлена для наглядности.
    allowedTCPPorts = [ vars.network.sshPort ];
    # KDE Connect (в Home Manager запускается только сама служба; порты
    # открывать можно лишь на системном уровне).
    allowedTCPPortRanges = [ vars.network.kdeconnectPorts ];
    allowedUDPPortRanges = [ vars.network.kdeconnectPorts ];
  };
}
