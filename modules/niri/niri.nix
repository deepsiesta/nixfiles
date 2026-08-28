{
  flake.modules.nixos.niri = {pkgs, ...}: {
    programs.niri.enable = true;
    services.gnome.gnome-keyring.enable = true;

    environment.systemPackages = with pkgs; [
      xwayland-satellite
      jq
    ];

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };

  flake.modules.homeManager.niri = {config, ...}: {
    xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/modules/niri/config.kdl";
  };
}
