{ config, lib, pkgs, ... }:

let
  theme = import ../themes/current;
  pkgs = import <nixpkgs> {};
  proportionalFont = builtins.getEnv "PROPORTIONAL_FONT_FAMILY";
  monospaceFont = builtins.getEnv "MONOSPACE_FONT_FAMILY";
  fontSize = builtins.getEnv "FONT_SIZE" || 10;
  tabs = rec {
    bar.bg = theme.light.gray;
    even = { bg = bar.bg; fg = theme.black; }; odd = even;
    selected = rec { even = { bg = theme.background; fg = theme.lightWhite; }; odd = even; };
  };

in {
  environment.systemPackages = with pkgs; [ qutebrowser ];

  home-manager.users.avo
    .xdg.configFile."qutebrowser/autoconfig.yml".text = lib.generators.toYAML {} {
      "config_version" = 2;
      "settings" = {
        "aliases".global = {
          q = "quit";
          w = "session-save";
          wq = "quit --save";
        };

        "auto_save.session".global = true;

        "backend".global = "webengine";

        "bindings.commands".global = {
          normal = {
            "!" = "spawn --userscript run-in-shell";
            "<Ctrl+Tab>" = "tab-next";
            "<Shift+Space>" = "scroll-page 0 -0.5";
            "<Space>" = "scroll-page 0 0.5";
            "e" = "spawn emacsbrowseurl {url}";
            "m" = "spawn --userscript ${pkgs.qutebrowser}/share/qutebrowser/userscripts/view_in_mpv {url}";
          };
        };

        "colors.completion.category.bg".global                 = theme.background;
        "colors.completion.category.fg".global                 = theme.lightWhite;
        "colors.completion.even.bg".global                     = theme.light.gray;
        "colors.completion.fg".global                          = [ theme.gray theme.gray theme.gray ];
        "colors.completion.item.selected.bg".global            = theme.background;
        "colors.completion.item.selected.border.bottom".global = theme.background;
        "colors.completion.item.selected.border.top".global    = theme.background;
        "colors.completion.item.selected.fg".global            = theme.lightWhite;
        "colors.completion.match.fg".global                    = theme.background;
        "colors.completion.odd.bg".global                      = theme.light.gray;
        "colors.completion.scrollbar.bg".global                = theme.black;
        "colors.completion.scrollbar.fg".global                = theme.darkGray;
        "colors.prompts.bg".global                             = theme.gray;
        "colors.prompts.border".global                         = "0";
        "colors.prompts.fg".global                             = theme.white;
        "colors.statusbar.insert.fg".global                    = theme.white;
        "colors.statusbar.normal.bg".global                    = theme.black;
        "colors.statusbar.normal.fg".global                    = theme.white;
        "colors.statusbar.url.error.fg".global                 = theme.yellow;
        "colors.statusbar.url.fg".global                       = theme.white;
        "colors.tabs.bar.bg".global                            = tabs.bar.bg;
        "colors.tabs.even.bg".global                           = tabs.even.bg;
        "colors.tabs.even.fg".global                           = tabs.even.fg;
        "colors.tabs.odd.bg".global                            = tabs.odd.bg;
        "colors.tabs.odd.fg".global                            = tabs.odd.fg;
        "colors.tabs.selected.even.bg".global                  = tabs.selected.even.bg;
        "colors.tabs.selected.even.fg".global                  = tabs.selected.even.fg;
        "colors.tabs.selected.odd.bg".global                   = tabs.selected.odd.bg;
        "colors.tabs.selected.odd.fg".global                   = tabs.selected.odd.fg;
        "colors.webpage.bg".global                             = "#eee";

        "completion.height".global = "30%";

        "downloads.location.prompt".global   = false;
        "downloads.location.remember".global = true;
        "downloads.open_dispatcher".global   = null;
        "downloads.position".global          = "bottom";
        "downloads.remove_finished".global   = 0;

        "editor.command".global = [
          "emacsclient"
          "-s"
          "scratchpad"
          "--eval"
          "(progn (find-file \"{}\") (evil-append-line 1))"
        ];
        "editor.encoding".global = "utf-8";

        "fonts.completion.category".global = "bold 10pt ${proportionalFont}";
        "fonts.completion.entry".global    = "10pt ${proportionalFont}";
        "fonts.debug_console".global       = "10pt ${monospaceFont}";
        "fonts.downloads".global           = "10pt ${monospaceFont}";
        "fonts.hints".global               = "bold 10pt ${monospaceFont}";
        "fonts.keyhint".global             = "10pt ${monospaceFont}";
        "fonts.messages.error".global      = "10pt ${monospaceFont}";
        "fonts.messages.info".global       = "10pt ${monospaceFont}";
        "fonts.messages.warning".global    = "10pt ${monospaceFont}";
        "fonts.monospace".global           = ''"${monospaceFont}"'';
        "fonts.prompts".global             = "10pt ${proportionalFont}";
        "fonts.statusbar".global           = "10pt ${proportionalFont}";
        "fonts.tabs".global                = "10pt ${proportionalFont}";
        "fonts.web.family.standard".global = null;

        "hints.mode".global      = "letter";
        "hints.uppercase".global = true;

        "input.insert_mode.auto_load".global = false;

        "scrolling.bar".global    = true;
        "scrolling.smooth".global = true;

        "session.lazy_restore".global = true;

        "statusbar.hide".global    = true;
        "statusbar.padding".global = { top = 6; right = 2; bottom = 5; left = 2; };
        "statusbar.widgets".global = [ "keypress" "url" "scroll" "history" "tabs" "progress" ];

        "tabs.background".global             = true;
        "tabs.favicons.scale".global         = 1;
        "tabs.favicons.show".global          = true;
        "tabs.indicator.width".global        = 0;
        "tabs.mode_on_change".global         = "normal";
        "tabs.new_position.unrelated".global = "next";
        "tabs.padding".global                = { top = 5; right = 7; bottom = 5; left = 7; };
        "tabs.position".global               = "right";
        "tabs.select_on_remove".global       = "next";
        "tabs.show".global                   = "always";
        "tabs.show_switching_delay".global   = 800;
        "tabs.title.format".global           = "{title}";
        "tabs.width".global                  = 370;
        "tabs.wrap".global                   = true;

        "url.default_page".global          = "about:blank";
        "url.incdec_segments".global       = [ "path" "query"];
        "url.searchengines".global.DEFAULT = "https://www.google.com/search?q={}";
        "url.start_pages".global           = "about:blank";

        "window.hide_wayland_decoration".global = false;

        "zoom.default".global       = "100%";
        "zoom.levels".global        = [ "25%" "33%" "50%" "67%" "75%" "90%" "100%" "110%" "118%" "125%" "150%" "175%" "200%" "250%" "300%" "400%" "500%" ];
        "zoom.mouse_divider".global = 512;
      };
    };
}
