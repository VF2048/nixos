# Часовой пояс и локали.
{ lib, vars, ... }:
let
  # Все категории LC_*, которые используют региональную (русскую) локаль.
  regionalCategories = [
    "LC_ADDRESS" "LC_IDENTIFICATION" "LC_MEASUREMENT" "LC_MONETARY" "LC_NAME"
    "LC_NUMERIC" "LC_PAPER" "LC_TELEPHONE" "LC_TIME"
  ];
in
{
  time.timeZone = vars.host.timeZone;

  # Язык интерфейса и сообщений — английский...
  i18n.defaultLocale = vars.host.defaultLocale;
  # ...а форматы дат, чисел, валюты и т.д. — русские.
  i18n.extraLocaleSettings = lib.genAttrs regionalCategories (_: vars.host.regionalLocale);
}
