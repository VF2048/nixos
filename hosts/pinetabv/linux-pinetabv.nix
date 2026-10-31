# Ядро PineTab-V: StarFive-форк Linux 6.6.20 с LOCALVERSION "-pinetabv".
# Исходники: starfive-tech/linux, ветка pinetabv-6.6.y-devel
# (submodule в starfive-tech/pinetab-v), коммит ниже.
# Конфиг: полный снимок с работающего устройства (raw/kernel-config-6.6.20-pinetabv.config).
{ pkgs }:

pkgs.linuxKernel.manualConfig {
  version = "6.6.20";
  modDirVersion = "6.6.20-pinetabv";

  src = pkgs.fetchFromGitHub {
    owner = "starfive-tech";
    repo = "linux";
    rev = "8587185299e8b1625deda5471a0329903e4a73e5";
    hash = "sha256-A+6LiJdxIS2VFafnc6OGrgg/FEooalu5tLMLql4j/8Q=";
  };

  configfile = ./kernel-config-6.6.20-pinetabv.config;
  allowImportFromDerivation = true;
}
