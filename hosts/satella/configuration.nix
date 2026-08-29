{
  flake.modules.nixos.satella = {
    pkgs,
    inputs,
    ...
  }: let
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
      "noctalia"
      "stylix"
      "gaming"
      "slack"
      "podman"
      "neovim"
      "starship"
      "tmux"
      "nushell"
      "fastfetch"
    ];
  in {
    imports = [
      ./hardware-configuration.nix
      inputs.nixos-hardware.nixosModules.framework-13-7040-amd
      (inputs.self.lib.loadHostModules modules "siesta")
    ];

    # Kernel
    # boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    hardware.cpu.amd.updateMicrocode = true;

    # Enable firmware updates
    services.fwupd.enable = true;

    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Encryption
    boot.initrd.luks.devices."luks-676832ae-1d58-4570-897f-0175565da880" = {
      device = "/dev/disk/by-uuid/676832ae-1d58-4570-897f-0175565da880";
      crypttabExtraOpts = ["fido2-device=auto"];
    };

    # Swapfile
    swapDevices = [
      {
        device = "/swap/swapfile";
        size = 34 * 1024;
      }
    ];

    # Enable flakes
    nix.settings.experimental-features = ["nix-command" "flakes"];

    networking.hostName = "satella"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Brightness control
    environment.systemPackages = [pkgs.brightnessctl];

    # Enable OpenGL
    hardware.graphics.enable = true;

    # Flatpak
    services.flatpak.enable = true;

    home-manager.users.siesta = {
      host.terminal.quickAccessLines = 20;
      wayland.windowManager.hyprland = {
        settings = {
          bindel = [
            " , XF86MonBrightnessUp, exec, brightnessctl set 10%+"
            " , XF86MonBrightnessDown, exec, brightnessctl set 10%-"
          ];
        };
      };
    };

    system.stateVersion = "26.05"; # Do not change this
  };
}
