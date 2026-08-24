{ config, pkgs, ... }:

{

  systemd.services.zapret = {
    enable = true;
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    description = "Zapret Discord & YouTube Service";

    path = with pkgs; [ 
      sudo 
      git 
      nftables 
      iptables 
      iproute2 
      coreutils 
      gawk 
      curl
    ];

    serviceConfig = {
        Type = "simple";
        WorkingDirectory="/etc/zapret/";
        User="root";

        Environment = "PATH=/run/current-system/sw/bin:/run/wrappers/bin";

        ExecStart = "${pkgs.bash}/bin/bash /etc/zapret/service.sh run --config conf.env";
        ExecStop = "${pkgs.bash}/bin/bash /etc/zapret/service.sh kill";
        ExecStopPost = "${pkgs.coreutils}/bin/echo 'Сервис завершён'";

        Restart = "on-failure";
        RestartSec = "5s";
    };
  };

}