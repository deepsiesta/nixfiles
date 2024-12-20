{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "siesta";
  home.homeDirectory = "/home/siesta";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.file = {
    ".local/share/thumbnailers/dds.thumbnailer".text = ''
      [Thumbnailer Entry]
      Exec=sh -c "${pkgs.imagemagick}/bin/convert -thumbnail x%s %i png:%o"
      MimeType=image/x-dds;
    '';
  };

  programs = {
    git = {
      enable = true;
      userName = "Siesta";
      userEmail = "20047950+deepsiesta@users.noreply.github.com";
    };
    # btop.enable = true;
    kitty = {
      enable = true;
      font = {
        name = "FiraCode Nerd Font";
        size = 12;
      };
      settings = {
        shell = "nu";
        background_opacity = "0.8";
        window_padding_width = 15;
        enable_audio_bell = "no";
        window_alert_on_bell = "no";
      };
      shellIntegration.enableFishIntegration = true;
    };
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };
    direnv = {
      enable = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
    };
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish | source
      '';
    };
    ranger = {
      enable = true;
      settings = {
        column_ratios = "1,3,3";
        preview_images = true;
        preview_images_method = "kitty";
      };
    };
  };

  imports = [
    ../../modules/home-manager/hyprland/hyprland.nix
    ../../modules/home-manager/hyprland/waybar.nix
    ../../modules/home-manager/hyprland/fuzzel.nix
    ../../modules/home-manager/starship/starship.nix
    ../../modules/home-manager/tmux/tmux.nix
    ../../modules/home-manager/nushell/nushell.nix
    ../../modules/home-manager/fastfetch/fastfetch.nix
    # ../../modules/home-manager/stylix/stylix.nix
  ];

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.tokyonight-gtk-theme;
      name = "Tokyonight-Dark";
    };
    iconTheme = {
      name = "candy-icons";
      # Merge Candy Icons and Sweet Folders into the same package
      package = pkgs.candy-icons.overrideAttrs (oldAttrs: {
        postInstall = ''
          cp ${pkgs.sweet-folders}/share/icons/Sweet-Rainbow/Places/* $out/share/icons/candy-icons/places/48
        '';
      });
    };
    font = {
      name = "Noto Sans";
      size = 12;
    };
  };

  qt = {
    enable = true;
    style.name = "adwaita-dark";
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        "DP-3, 2560x1440@144, 0x0, 1"
        "DP-1, 2560x1440@144, 2560x0, 1"
      ];
      workspace =
        [
          "special:scratchpad, name:scratchpad, monitor:DP-1"
        ]
        ++ (
          # Bind odd workspaces to left screen, even workspaces to right screen
          builtins.concatLists (builtins.genList (
              i: let
                wleft = 2 * i + 1;
                wright = 2 * i + 2;
              in [
                "${toString wleft}, monitor:DP-3"
                "${toString wright}, monitor:DP-1"
              ]
            )
            5) # Applies rules to workspaces 1 .. 10
        );
      exec-once = [
        "uwsm app -- ckb-next --background"
        "uwsm app -- steam -silent"
      ];
    };
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/siesta/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
