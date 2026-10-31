# Имя хоста, firewall и DNS-over-HTTPS.
{ vars, ... }: {
  networking.hostName = vars.host.hostName;

  # DoH через dnscrypt-proxy: обходит подмену DNS на роутере (провайдер не
  # отдаёт A-записи для youtube/googlevideo). Слушает 127.0.0.1:53.
  services.dnscrypt-proxy = {
    enable = true;
    settings = {
      listen_addresses = [ "127.0.0.1:53" ];
      ipv6_servers = false;
      require_dnssec = false;
      require_nolog = true;
      require_nofilter = true;
      server_names = [ "cloudflare" "quad9-doh-ip4-port443-nofilter-pri" ];
      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/cache/dnscrypt-proxy/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };
    };
  };

  networking.nameservers = [ "127.0.0.1" "::1" ];
  networking.resolvconf.useLocalResolver = true;

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
