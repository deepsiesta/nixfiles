{
  flake.modules.nixos.kanami = {
    pkgs,
    inputs,
    lib,
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
      "nvidia"
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

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Enable flakes
    nix.settings.experimental-features = ["nix-command" "flakes"];

    networking.hostName = "kanami"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Required by wireless card
    hardware.usb-modeswitch.enable = true;
    boot.initrd.kernelModules = ["rtw89_8852au"];
    services.udev.extraRules =
      # Switch card from storage mode to WiFi mode.
      ''
        ATTR{idVendor}=="0bda", ATTR{idProduct}=="1a2b", RUN+="${lib.getExe pkgs.usb-modeswitch} -K -v 0bda -p 1a2b"
      '';

    # Enable OpenGL
    hardware.graphics.enable = true;

    # Flatpak
    services.flatpak.enable = true;

    # Old GPUs cannot use the open kernel module
    host.nvidia.legacy = true;
    nixpkgs.config.nvidia.acceptLicense = true;

    home-manager.users.siesta = {
    };

    system.stateVersion = "24.05"; # Do not change this
  };
}
