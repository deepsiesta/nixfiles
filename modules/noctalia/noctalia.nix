{
  flake.modules.nixos.noctalia = {
    inputs,
    pkgs,
    ...
  }: {
    imports = [
      inputs.noctalia.nixosModules.default
    ];

    programs.noctalia = {
      enable = true;
      package = pkgs.noctalia;

      # Enables NetworkManager, Bluetooth, UPower, and a power profile service.
      recommendedServices.enable = true;
    };
  };
  flake.modules.homeManager.noctalia = {
    config,
    inputs,
    ...
  }: {
    imports = [inputs.noctalia.homeModules.default];

    # programs.noctalia = {
    #   enable = true;
    # };

    xdg.configFile."noctalia/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/modules/noctalia/config.toml";
  };
}
