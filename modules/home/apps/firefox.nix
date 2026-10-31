# Firefox с поддержкой захвата звука отдельных приложений (pipewire-screenaudio)
# и расширениями. Ставится как обычный пакет, а НЕ через programs.firefox: модуль
# Home Manager при stateVersion 26.05 может сменить каталог профиля.
# Расширения задаются политикой ExtensionSettings (installation_mode = force_installed).
{ pkgs, inputs, ... }:
let
  addons = inputs.nur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.repos.rycee.firefox-addons;

  # Расширения из NUR (подписанные XPI, с хэшем).
  fromNur = [
    addons.bitwarden
    addons.ublock-origin
    addons.darkreader
    addons.tridactyl
    addons.sponsorblock
  ];

  # AdGuard в NUR нет — ставим с AMO по URL (политика скачает и проверит подпись).
  extensionSettings = {
    "adguardadblocker@adguard.com" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/adguard-adblocker/latest.xpi";
      installation_mode = "force_installed";
    };
  } // builtins.listToAttrs (map (a: {
    name = a.addonId;
    value = {
      # NUR кладёт XPI в share/mozilla/extensions/<app-id>/<addonId>.xpi;
      # политике нужен путь к самому файлу, а не к каталогу.
      install_url = "file://${a}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${a.addonId}.xpi";
      installation_mode = "force_installed";
    };
  }) fromNur);
in {
  # Браузер по умолчанию для ссылок и HTML.
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
    };
  };

  home.packages = [
    (pkgs.firefox.override {
      # Native messaging host: связывает расширение браузера с PipeWire.
      nativeMessagingHosts = [
        inputs.pipewire-screenaudio.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
      extraPolicies = {
        ExtensionSettings = extensionSettings;
        # 3 = восстанавливать окна и вкладки с прошлого раза.
        Preferences = {
          "browser.startup.page" = {
            Value = 3;
            Status = "default";
            Type = "number";
          };
        };
      };
    })
  ];
}
