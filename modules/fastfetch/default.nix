{
  flake.modules.homeManager.fastfetch = _: {
    programs.fastfetch = {
      enable = true;
    };
    home.file.".config/fastfetch/config.jsonc".text = let
      ascii_logo =
        builtins.replaceStrings ["\n"] ["\\n"]
        (builtins.readFile ./logo.txt);
    in
      # JSONC
      ''
        {
          "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
          "logo": {
            "type": "data",
            "source": "${ascii_logo}",
            "color": {"1":"default"},
            "padding": {
              "top": 1,
              "right": 4
            }
          },
          "display": {
            "separator": " "
          },
          "modules": [
            "break",
            "break",
            {
              "type": "title",
              "keyWidth": 10
            },
            "break",
            {
              "type": "os",
              "format": "{3}",
              "key": " ",
              "keyColor": "36" // = color4
            },
            {
              "type": "kernel",
              "key": " ",
              "keyColor": "36"
            },
            {
              "type": "cpu",
              "format": "{1}",
              "key": " ",
              "keyColor": "36"
            },
            {
              "type": "gpu",
              "format": "{1} {2}",
              "key": "󰢮 ",
              "keyColor": "36"
            },
            {
              "type": "packages",
              // "format": "{} (nix)",
              "key": " ",
              "keyColor": "36"
            },
            {
              "type": "shell",
              "key": " ",
              "keyColor": "36"
            },
            {
              "type": "terminal",
              "key": " ",
              "keyColor": "36"
            },
            {
              "type": "wm",
              "key": " ",
              "keyColor": "36"
            },
            {
              "type": "theme",
              "key": " ",
              "keyColor": "36"
            },
            {
              "type": "terminalfont",
              //           "type": "font",
              "key": " ",
              "keyColor": "36"
            },
            "break",
            "colors",
            "break",
            "break"
          ]
        }
      '';
  };
}
