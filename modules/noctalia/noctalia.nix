{
  flake.modules.nixos.niri = {inputs, ...}: {
    imports = [
      inputs.noctalia.nixosModules.default
    ];

    programs.noctalia = {
      enable = true;

      # Enables NetworkManager, Bluetooth, UPower, and a power profile service.
      recommendedServices.enable = true;
    };
  };
  flake.modules.homeManager.niri = {
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
