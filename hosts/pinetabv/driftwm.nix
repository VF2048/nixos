# driftwm 0.21.0 (Wayland-композитор). В nixpkgs-pinetab пакета нет,
# а flake проекта не поддерживает riscv64, поэтому собираем вручную.
{ pkgs }:
pkgs.rustPlatform.buildRustPackage {
  pname = "driftwm";
  version = "0.21.0";
  src = pkgs.fetchFromGitHub {
    owner = "malbiruk";
    repo = "driftwm";
    rev = "e97a9d04fa95fa10f8909ffb5ce103ee02e20a8e";
    hash = "sha256-I96TIm1FDjcrOIk5pB/zEh7KpXWaWLDzFhmvpGRuhaA=";
  };
  cargoLock = {
    lockFile = ./driftwm-Cargo.lock;
    outputHashes = {
      "smithay-0.7.0" = "sha256-2aurK1dZAD49FTYURzZuQkBM07woZB/rNymF0fuSbR8=";
    };
  };
  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = with pkgs; [
    wayland
    wayland-protocols
    seatd
    libdisplay-info_0_3
    libinput
    libgbm
    libxkbcommon
    libdrm
    systemd
    libglvnd
    libx11
    libxcursor
    libxrandr
    libxi
    libxcb
    pixman
  ];
}
