{
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.desktops.kde;
in {
  options.modules.desktops.kde = {
    enable = mkEnableOption "Enable KDE (Plasma5) desktop";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
    };

    environment.systemPackages = with pkgs; [
      libsForQt5.bismuth
      plasma5Packages.plasma-thunderbolt
    ];

    programs.kdeconnect.enable = true;
  };
}
