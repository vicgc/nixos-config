{ pkgs, ... }:

let
  theme = import ./challenger-deep-theme.nix;
  myFonts = {
    proportional = "Abel";
    monospace = "Source Code Pro";
    defaultSize = 10;
  };

in {
  home-manager.users.avo = {
    xresources.properties = {
      "Xft.dpi"       = 180;
      "*.font"        = "xft:${myFonts.monospace}:size=${toString myFonts.defaultSize}";
      } // (with theme; {
        "*.background" = background; "*.foreground" = foreground;
        "*.color0"     = black;      "*.color8"     = gray;
        "*.color1"     = red;        "*.color9"     = lightRed;
        "*.color2"     = green;      "*.color10"    = lightGreen;
        "*.color3"     = yellow;     "*.color11"    = lightYellow;
        "*.color4"     = blue;       "*.color12"    = lightBlue;
        "*.color5"     = magenta;    "*.color13"    = lightMagenta;
        "*.color6"     = cyan;       "*.color14"    = lightCyan;
        
        "*.borderColor" = background;
        "*.colorUL"     = white;
        "*.cursorColor" = foreground;
    }) // (let launcherFontSize = "28"; in {
      "rofi.font"  = "${myFonts.proportional} ${launcherFontSize}";
      "rofi.theme" = "avo";
    });
    
    xsession = {
      enable = true;
      windowManager.command = "~/.local/bin/xmonad";
      initExtra =
      let wallpaperPath = "~/data/wallpapers/matterhorn.jpg";
        in with pkgs; ''
        ${xorg.xsetroot}/bin/xsetroot -xcf ${gnome3.adwaita-icon-theme}/share/icons/Adwaita/cursors/left_ptr 36
        
        ${setroot}/bin/setroot -z ${wallpaperPath} -z ${wallpaperPath} -z ${wallpaperPath}
        
        while sleep 1; do
        systemctl --user --state active list-units emacs.service && {
          (sleep 3 && ${pkgs.emacs}/bin/emacsclient --create-frame --no-wait) &
          break
        }
        done
        
        ${pkgs.qutebrowser}/bin/qutebrowser &
        '';
    };

    xdg.configFile = {
      "xmobar/xmobarrc".text =
         import ./xmobarrc.nix {
           inherit theme;
           font = myFonts.proportional;
         };

      "xmobar/bin/online-indicator" = {
        text = with theme; ''
          color=$(is-online && echo '${green}' || echo '${red}')
          symbol=$(is-online && echo ﯱ || echo ﯱ)

          echo "<fc=$color>$symbol</fc>"
        '';
        executable = true;
      };
     };
  };
} // {
  fonts = {
    fontconfig = {
      ultimate.enable = false;
      defaultFonts = {
        monospace = [ myFonts.monospace ];
        sansSerif = [ myFonts.proportional ];
      };
    };
    enableCoreFonts = true;
    fonts = with pkgs; [
      emacs-all-the-icons-fonts
      font-awesome-ttf
      google-fonts
      hack-font
      hasklig
      iosevka-custom
      material-icons
      nerdfonts
      overpass
      powerline-fonts
      terminus_font
      ubuntu_font_family
      vistafonts
    ];
  };
}