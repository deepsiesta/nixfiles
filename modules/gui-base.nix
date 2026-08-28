{
  flake.modules.nixos.gui-base = {pkgs, ...}: {
    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };

    environment.systemPackages = with pkgs; [
      wl-clipboard
    ];
  };

  flake.modules.homeManager.gui-base = {
    lib,
    pkgs,
    ...
  }: {
    programs.waybar = {
      enable = false;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 32;
          modules-left = ["niri/window"];
          modules-center = ["niri/workspaces"];
          modules-right = ["tray" "wireplumber" "battery" "clock"];

          "niri/window" = {
            format = "{}";
            separate-outputs = true;
          };

          "niri/workspaces" = {
            disable-scroll = true;
            persistent_workspaces = {
              "1" = [];
              "2" = [];
              "3" = [];
              "4" = [];
              "5" = [];
              "6" = [];
              "7" = [];
              "8" = [];
              "9" = [];
              "0" = [];
            };
          };

          "tray" = {
            icon-size = 16;
            spacing = 10;
          };

          "wireplumber" = {
            format = "{icon}";
            tooltip-format = "{node_name}\n{volume}%";
            format-muted = "";
            on-click = "pwvucontrol";
            scroll-step = 2;
            format-icons = ["" "" ""];
          };

          "battery" = {
            interval = 60;
            states = {
              warning = 30;
              critical = 10;
            };
            format = "{capacity}% {icon}";
            format-icons = ["" "" "" "" ""];
            max-length = 25;
          };

          "clock" = {
            interval = 60;
            format = "{:%a %d/%m %H:%M}";
          };
        };
      };
      style =
        # CSS
        ''
          * {
            border: none;
            border-radius: 0;
            padding: 0;
            margin: 0;
            font-size: 14px;
            font-weight: bold;
          }

          window#waybar {
            background: rgba(10, 10, 10, 0.4);
            color: #ffffff;
          }

          #window {
            margin-left: 15px;
          }

          #workspaces button {
            font-size: 16px;
            margin-right: 10px;
            color: #ffffff;
          }

          #workspaces button.hover {
            background-color: rgba(20, 20, 60, 0.6);
            /* color: #ffffff; */
          }

          #workspaces button.active {
            color: #FFA328;
          }

          #tray {
            margin-right: 15px;
          }

          #wireplumber {
            margin-right: 15px;
          }

          #battery {
            margin-right: 15px;
          }

          #clock {
            margin-right: 15px;
          }
        '';
    };

    services.xembed-sni-proxy.enable = true;

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    gtk = {
      enable = true;
      iconTheme = {
        name = "Sweet-Rainbow";
        package = pkgs.sweet-folders;
      };
    };

    home.packages = with pkgs; [
      candy-icons
    ];

    programs.fuzzel = {
      enable = false;
      settings = {
        main = {
          width = 30;
          vertical-pad = 12;
          line-height = 28;
          font = "Noto Sans:size=12";
        };
        colors = lib.mkForce {
          background = "000000cc";
          text = "ffffffff";
          selection = "121212dd";
          selection-text = "30c0f0dd";
          border = "30c0f0ff";
        };
        border = {
          width = 2;
          radius = 0;
        };
      };
    };

    qt = {
      enable = true;
    };
  };
}
