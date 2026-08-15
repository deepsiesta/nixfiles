{
  flake.modules.nixos.stargazer = {inputs, ...}: let
    modules = [
      "common"
      "audio"
      "fonts"
      "sddm"
      "gui-utils"
      "gui-base"
      "thunar"
      "multimedia"
      "productivity"
      "development"
      "gemini"
      "niri"
      "stylix"
      "gaming"
      "obs"
      "aagl"
      "podman"
      "nvidia"
      "cuda"
      "neovim"
      "starship"
      "tmux"
      "nushell"
      "fastfetch"
    ];
  in {
    imports = [
      ./hardware-configuration.nix
      (inputs.self.lib.loadHostModules modules "siesta")
    ];

    # Kernel
    # boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    hardware.cpu.intel.updateMicrocode = true;

    # Enable firmware updates
    services.fwupd.enable = true;

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Enable flakes
    nix.settings.experimental-features = ["nix-command" "flakes"];

    networking.hostName = "stargazer"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Logitech wireless support/configuration
    hardware.logitech.wireless.enable = true;
    programs.solaar.enable = true;

    # Corsair keyboard etc. support
    hardware.ckb-next.enable = true;

    # Xbox Controller
    hardware.xone.enable = true;

    # Enable OpenGL
    hardware.graphics.enable = true;

    # Flatpak
    services.flatpak.enable = true;

    home-manager.users.siesta = {
      xdg.configFile."niri/display.kdl".text =
        # KDL
        ''
          output "HDMI-A-1" {
              mode "2840x1260@60"
              scale 2
              position x=-1920 y=0
          }
          output "DP-1" {
              mode "2560x1440@143.972"
          }
        '';

      xdg.configFile."niri/extra.kdl".text =
        # KDL
        ''
          spawn-at-startup "ckb-next" "--background"
          spawn-at-startup "solaar" "--window" "hide"
          spawn-sh-at-startup "sleep 1 && steam -silent"
        '';
    };

    system.stateVersion = "24.05"; # Do not change this
  };
}
