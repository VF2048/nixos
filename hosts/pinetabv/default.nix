# Точка входа хоста "pinetabv" (PineTab-V, StarFive JH7110, riscv64).
# Конфигурация описана в pinetabv-nixos-description/. Образ — SD-карта.
{ config, inputs, vars, lib, pkgs, ... }: {
  imports = [
    "${inputs.nixpkgs-pinetab}/nixos/modules/installer/sd-card/sd-image.nix"

    ../../modules/nixos/base.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/security.nix
    ../../modules/nixos/packages.nix
  ];

  nixpkgs.buildPlatform = "x86_64-linux";
  nixpkgs.hostPlatform = "riscv64-linux";

  networking.hostName = lib.mkForce "pinetabv";

  # Ядро и загрузка — см. 01-hardware.md и 02-boot.md.
  boot.kernelPackages = pkgs.linuxPackagesFor (import ./linux-pinetabv.nix { inherit pkgs; });
  boot.kernelParams = [
    "console=tty0" "console=ttyS0,115200" "earlycon"
    "rootwait" "stmmaceth=chain_mode:1" "selinux=0"
    "root=fstab" "loglevel=4" "lsm=landlock,yama,bpf"
  ];
  boot.kernelModules = [ "btusb" "btrtl" "btintel" "wave5" "e24" "starfive_mailbox" ];
  # Все модули для загрузки с SD (mmc, ext4, vfat) вкомпилированы в ядро,
  # поэтому initrd не требует внешних модулей.
  hardware.enableAllHardware = lib.mkForce false;
  boot.initrd.availableKernelModules = lib.mkForce [ ];
  boot.initrd.kernelModules = lib.mkForce [ ];
  hardware.deviceTree.name = "starfive/jh7110-pinetab-v.dtb";
  hardware.enableRedistributableFirmware = true;
  # linux-firmware даёт rtl_bt/rtl8852bu_fw (Bluetooth) и cnm/wave521c (видеодекодер wave5).
  # Драйвер PowerVR (pvrsrvkm) не читает сжатые прошивки (.zst): отключаем сжатие.
  hardware.firmwareCompression = "none";
  # pvrsrvkm стартует на ~3,5 с, раньше монтирования /nix/store: прошивка GPU должна быть в initrd.
  boot.initrd.extraFirmwarePaths = [ "rgx.fw.36.50.54.182" "rgx.sh.36.50.54.182" ];
  # GPU PowerVR (rgx) из img-gpu-powervr-bin-1.17.6210866 (StarFive, проприетарный blob).
  hardware.firmware = [
    pkgs.linux-firmware
    (pkgs.runCommand "pinetabv-gpu-firmware" { } ''
      mkdir -p $out/lib/firmware
      cp ${./firmware/lib/firmware}/rgx.* $out/lib/firmware/
    '')
  ];

  boot.loader.generic-extlinux-compatible = {
    enable = true;
    configurationLimit = 20;
    # extlinux.conf читает U-Boot с NIXBOOT (/boot/firmware), а не с /boot на корне.
    mirroredBoots = [ { path = "/boot/firmware"; } ];
  };
  boot.loader.timeout = 3;
  boot.loader.grub.enable = false;

  # extlinux и ядро лежат на NIXBOOT (/boot/firmware), как на устройстве.
  # sd-image по умолчанию ставит noauto: тогда switch не обновляет extlinux.conf.
  fileSystems."/boot/firmware".options = lib.mkForce [ "nofail" ];

  sdImage = {
    # Метки как на устройстве: корень NIXROOT, загрузка NIXBOOT (см. /etc/fstab на планшете).
    rootVolumeLabel = "NIXROOT";
    firmwarePartitionName = "NIXBOOT";
    # Размер как на устройстве (NIXBOOT 256 МБ); ядро + initrd + DTB не помещаются в дефолтные 30 МБ.
    firmwareSize = 256;
    populateFirmwareCommands = ''
      mkdir -p ./firmware
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./firmware
    '';
    populateRootCommands = "";
  };

  # Сетевой стек: NetworkManager вместо скриптовой сети.
  networking.networkmanager = {
    enable = true;
    wifi.backend = "wpa_supplicant";
    wifi.scanRandMacAddress = true;
    dns = "default";
  };
  networking.nftables.enable = true;
  networking.resolvconf.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      UseDns = false;
    };
  };

  nix.settings = {
    substituters = [ "https://cache.nixos.org/" ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "pc-pinetabv-1:wOEFc4+fjk8C8vuW1ltomspAyQUseLO95e/AQzKy6W4="
    ];
    trusted-users = [ "root" ];
    sandbox = true;
  };

  # Пользователь как на устройстве: uid 1000, bash по умолчанию (fish не используется).
  users.users.${vars.user.name} = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    extraGroups = [ "wheel" "networkmanager" ];
    hashedPassword = "$6$ucwhUALzONWCKuEU$bA1v9ULTLyK.oQPKUD/ylDKzg4CdVJeZVqSrnTmFKcNOfPMZiIAXD/tONbWPudnEyGD/ZOgXOrOjZlt7vnsKx1";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILNXzRQNRqUK2IQE1zXBW2GKgMh/13b3briXc0aw/qut vfok@nixos"
    ];
  };
  users.defaultUserShell = pkgs.bashInteractive;

  environment.systemPackages = [ (import ./driftwm.nix { inherit pkgs; }) ];
  security.sudo.wheelNeedsPassword = false;
}
