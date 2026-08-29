{
  flake.modules.homeManager.fastfetch = _: let
    terminalFontCmd =
      # bash
      ''
        font=$(awk '/^font_family/ {$1=""; sub(/^ /, ""); print}' ~/.config/kitty/kitty.conf \
          | sed 's/\([a-z]\)\([A-Z]\)/\1 \2/g')
        size=$(awk '/^font_size/ {print $2}' ~/.config/kitty/kitty.conf)
        echo "$font (''${size}pt)"
      '';
    systemAgeCmd =
      # bash
      ''
        f() {
          [ $1 -gt 0 ] && echo "$1 $2$([ $1 -ne 1 ] && echo s) "
        }
        b=$(stat -c %W / 2>/dev/null)
        [ "$b" = "0" ] && b=$(stat -c %Y /)
        d=$(($(date +%s) - b))
        y=$((d / 31536000))
        rem=$((d % 31536000))
        m=$((rem / 2592000))
        day=$(((rem % 2592000) / 86400))
        out="$(f $y year)$(f $m month)$(f $day day)"
        echo "''${out:-Today}"
      '';
  in {
    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          type = "data";
          source = builtins.readFile ./logo.txt;
          color = {"1" = "default";};
          padding = {
            top = 1;
            right = 4;
          };
        };
        display.separator = " ";
        modules = [
          "break"
          {
            type = "title";
            keyWidth = 10;
          }
          "break"
          {
            type = "os";
            format = "{3}";
            key = " ";
            keyColor = "36";
          }
          {
            type = "kernel";
            key = " ";
            keyColor = "36";
          }
          {
            type = "cpu";
            format = "{1}";
            key = " ";
            keyColor = "36";
          }
          {
            type = "gpu";
            format = "{1} {2}";
            key = "󰢮 ";
            keyColor = "36";
          }
          {
            type = "packages";
            key = " ";
            keyColor = "36";
          }
          "break"
          {
            type = "wm";
            key = " ";
            keyColor = "36";
          }
          {
            type = "command";
            key = " ";
            keyColor = "36";
            text =
              # bash
              ''
                awk -F'"' '/^(builtin|community_palette|custom_palette) =/ {print $2; exit}' ~/.config/noctalia/config.toml
              '';
          }
          {
            type = "terminal";
            key = " ";
            keyColor = "36";
          }
          {
            type = "shell";
            key = " ";
            keyColor = "36";
          }
          {
            type = "command";
            key = " ";
            keyColor = "36";
            text = terminalFontCmd;
          }
          "break"
          {
            type = "command";
            key = "󰔠 ";
            text = systemAgeCmd;
          }
          {
            type = "command";
            key = "󰚰 ";
            text =
              # bash
              ''
                echo "Generation $(readlink /nix/var/nix/profiles/system | cut -d'-' -f2)"
              '';
          }
          "break"
          "colors"
          "break"
          "break"
        ];
      };
    };
  };
}
