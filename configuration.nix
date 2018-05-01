{ config, lib, pkgs, ... }:

let
  makeEmacsDaemon = import ./make-emacs-daemon.nix;

  theme = import ./challenger-deep-theme.nix;
  proportionalFont = "Abel"; monospaceFont = "Source Code Pro";
  fontSize = 10; launcherFontSize = "28";

  myName = "Andrei Vladescu-Olt"; myEmail = "andrei@avolt.net";

  overlays =
    let path = ./overlays; in with builtins;
    map (n: import (path + ("/" + n)))
        (filter (n: match ".*\\.nix" n != null ||
                    pathExists (path + ("/" + n + "/default.nix")))
                (attrNames (readDir path)));

in {
  imports =
    [
      ./hardware-configuration.nix

      ./home-manager/nixos

      ./android.nix
      ./clojure.nix
      ./docker.nix
      ./email.nix
      ./git.nix
      ./google-drive-ocamlfuse-service.nix
      ./gui.nix
      ./haskell.nix
      ./ipfs.nix
      ./libvirt.nix
      ./networking.nix
      ./packages.nix
      ./printing.nix
      ./shell.nix
    ];

  boot.loader.timeout = 1;

  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 100000;
    "vm.swappiness" = 1;
    "vm.vfs_cache_pressure" = 50;
    "kernel.core_pattern" = "|/run/current-system/sw/bin/false"; # disable core dumps
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.pathsToLink = [ "/share/zsh" ];

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";

  system = {
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
  };

  nix = {
    buildCores = 0;
    gc.automatic = true;
    optimise.automatic = true;
  };

  nixpkgs = {
    overlays = overlays;
    config.allowUnfree = true;
  };

  hardware = {
    bluetooth.enable = true;

    opengl = {
      driSupport = true;
      driSupport32Bit = true;
    };

    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      extraClientConf = ''
        auth-cookie = "/tmp/pulse/esd-auth-cookie";
      '';
    };
  };

  hardware.opengl.extraPackages = with pkgs; [ vaapiVdpau ];

  services = {
    devmon.enable = true;

    mopidy = {
      enable = true;
      extensionPackages = with pkgs; [ mopidy-gmusic ];
      configuration = lib.generators.toINI {} {
        gmusic = {
          deviceid = "0123456789abcdef";
          username = "andreivolt";
          password = builtins.getEnv "ANDREIVOLT_GOOGLE_PASSWORD";
          bitrate = 320;
        };
      };
    };

    bitlbee = {
      enable = true;
      libpurple_plugins = with pkgs; [ telegram-purple ];
    };

    emacs.enable = true;

    xserver = {
      enable = true;

      # displayManager.sddm.enable = true;
      # windowManager.sway.enable = true;
      layout = "fr";
      xkbOptions = "ctrl:nocaps";

      videoDrivers = [ "nvidia" ];

      libinput = {
        enable = true;
        naturalScrolling = true;
        accelSpeed = "0.4";
      };

      xrandrHeads =
        let withNvidiaTearingFix = { position, rotation ? "normal" }: ''
          Option "metamodes" "nvidia-auto-select ${position} {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On, Rotate=${rotation}}"
          Option "AllowIndirectGLXProtocol" "off"
          Option "TripleBuffer" "on"
        ''; in [
          {
            output = "DP-2";
            monitorConfig = withNvidiaTearingFix { position = "+2160+0"; rotation = "left"; };
          }
          {
            output = "DP-4";
            primary = true;
            monitorConfig = withNvidiaTearingFix { position = "+3840+2160"; };
          }
          {
            output = "DP-0";
            monitorConfig = withNvidiaTearingFix { position = "+3840+0"; };
          }
        ];

      displayManager = {
        auto = {
          enable = true;
          user = "avo";
        };
      };

      desktopManager.xterm.enable = false;
    };

  };

  users.users.avo = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  home-manager.users.avo = let home_directory = builtins.getEnv "HOME"; in rec {
    services.dropbox.enable = true;

    home = {
      packages = with pkgs; [];

      keyboard = {
        layout = "fr";
        options = [ "ctrl:nocaps" ];
      };

      sessionVariables = {
        ALTERNATE_EDITOR  = "${pkgs.neovim}/bin/nvim";
        BROWSER           = "${pkgs.qutebrowser}/bin/qutebrowser-open-in-instance";
        EDITOR            = ''
                              ${pkgs.emacs}/bin/emacsclient \
                              --tty \
                              --create-frame'';
        PATH              = lib.concatStringsSep ":" [
                              "$PATH"
                              "$HOME/bin"
                              "${xdg.cacheHome}/npm/packages/bin"
                            ];
        GNUPGHOME         = "${xdg.configHome}/gnupg";
        LESSHISTFILE      = "${xdg.cacheHome}/less/history";
        LIBVA_DRIVER_NAME = "vdpau";
        PARALLEL_HOME     = "${xdg.cacheHome}/parallel";
        WWW_HOME          = "${xdg.cacheHome}/w3m";
      };

      file = {
        ".trc".text =
          let
            username       = "andreivolt";
            consumerKey    = builtins.getEnv "TWITTER_CONSUMER_KEY";
            consumerSecret = builtins.getEnv "TWITTER_CONSUMER_SECRET";
            token          = builtins.getEnv "TWITTER_TOKEN";
            secret         = builtins.getEnv "TWITTER_SECRET";
          in ''
            ---
            configuration:
              default_profile:
              - ${username}
              - ${consumerKey}
            profiles:
              ${username}:
                ${consumerKey}:
                  username: ${username}
                  consumer_key: ${consumerKey}
                  consumer_secret: ${consumerSecret}
                  token: ${token}
                  secret: ${secret}
          '';

        ".tmux.conf".text = ''
          set -g @plugin 'tmux-plugins/tpm'

          set -g @plugin 'tmux-plugins/tmux-sensible'

          set -g @plugin 'tmux-plugins/tmux-pain-control'

          set -g @plugin 'nhdaly/tmux-better-mouse-mode'
          set -g @scroll-speed-num-lines-per-scroll 1
          set -g mouse on

          set -g @plugin 'tmux-plugins/tmux-copycat'
          set -g @plugin 'tmux-plugins/tmux-yank'
          set -g @yank_selection 'primary'
          bind -T copy-mode-vi v   send -X begin-selection
          bind -T copy-mode-vi C-v send -X rectangle-toggle
          bind -T copy-mode-vi y   send -X copy-selection
          unbind p
          bind   p paste-buffer

          run '~/.tmux/plugins/tpm/tpm'

          set  -g base-index 1
          set  -g renumber-windows on
          set  -g monitor-activity on
          set  -g set-titles on
          set  -g set-titles-string "#T"

          set  -g status-style                 bg='${theme.background}',fg='${theme.foreground}'
          set  -g status-left                  '''
          set  -g status-right                 ' #S '
          set  -g window-status-format         ' #I: #W '
          set  -g window-status-current-format ' #I: #W '
          setw -g window-status-current-style  bg='${theme.black}',fg='${theme.white}'
          setw -g window-status-activity-style bg='${theme.yellow}'

          set  -g prefix C-a
          setw -g mode-keys vi
          set  -g mode-keys vi

          bind C-o previous-window
          bind C-i next-window
          bind s   split-window -v
          bind v   split-window -h
        '';

        ".gist".text = builtins.getEnv "GIST_TOKEN";
      };
    };

    xdg = {
      enable = true;

      configHome = "${home_directory}/.config";
      dataHome   = "${home_directory}/.local/share";
      cacheHome  = "${home_directory}/.cache";

      configFile = {
        "bitcoin/bitcoin.conf".text = lib.generators.toKeyValue {} {
          prune = 550;
        };

        "mitmproxy/config.yaml".text = ''
           CA_DIR: ${xdg.configHome}/mitmproxy/certs
        '';

        "youtube-dl.conf".text = ''
           --output %(title)s.%(ext)s
        '';

        "qutebrowser/autoconfig.yml".text =
          import ./qutebrowser.nix {
            inherit theme
                    proportionalFont
                    monospaceFont
                    pkgs;
          };

        "user-dirs.dirs".text = lib.generators.toKeyValue {} {
          XDG_DOWNLOAD_DIR = "$HOME/tmp";
          XDG_DESKTOP_DIR  = "$HOME/tmp";
        };

        "mimeapps.list".text = lib.generators.toINI {} {
           "Default Applications" = {
             "x-scheme-handler/http"                                                   = "qutebrowser.desktop";
             "x-scheme-handler/https"                                                  = "qutebrowser.desktop";
             "x-scheme-handler/ftp"                                                    = "qutebrowser.desktop";
             "text/html"                                                               = "qutebrowser.desktop";
             "application/xhtml+xml"                                                   = "qutebrowser.deskop";
             "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "libreoffice-writer.desktop";
             "application/pdf"                                                         = "zathura.desktop";
             "text/plain"                                                              = "emacs.desktop";
             "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"       = "calc.desktop";
             "application/xml"                                                         = "emacs.desktop";
             "x-scheme-handler/magnet"                                                 = "userapp-transmission-gtk-NWT3FZ.desktop";
           };
         };
      };
    };

    nixpkgs.config = {
      allowUnfree = true;
    };

    programs = {
      aws-cli = {
        enable = true;
        config = {
          default = {
            region = "eu-west-1";
          };
        };
        credentials = {
          default = {
            aws_access_key_id     = builtins.getEnv "AWS_ACCESS_KEY_ID";
            aws_secret_access_key = builtins.getEnv "AWS_SECRET_ACCESS_KEY";
          };
        };
      };

      home-manager.enable = true;

      nodejs.enable = true;

      curl = {
        enable = true;
        config = ''
          user-agent mozilla
          silent
          globoff
        '';
      };

      zathura = {
        enable = true;
        config = ''
          set incremental-search true
        '';
      };

      pianobar = {
        enable = true;
        config = {
          user = "andrei.volt@gmail.com";
          password = builtins.getEnv "PANDORA_PASSWORD";
          audio_quality = "high";
        };
      };

      httpie = {
        enable = true;
        defaultOptions = [
          "--pretty" "format"
          "--session" "default"
        ];
      };

      alacritty = {
        enable = true;
        config =
          import ./alacritty.nix {
            inherit theme monospaceFont;
            fontSize = fontSize;
          };
      };

      mpv = {
        enable = true;
        config = {
          ao = "pulse";
          hwdec = "vdpau";
          profile = "opengl-hq";
          audio-display = "no";
        };
      };

      htop = {
        enable = true;
        fields = [
          "USER"
          "PRIORITY"
          "STATE"
          "PERCENT_CPU"
          "PERCENT_MEM"
          "TIME"
          "IO_READ_RATE"
          "IO_WRITE_RATE"
          "STARTTIME"
          "COMM"
        ];
        accountGuestInCpuMeter = false;
        colorScheme = 6;
        hideUserlandThreads = true;
        meters = {
          left = [
            "Memory"
            "CPU"
            "LoadAverage"
          ];
          right = [
            "Tasks"
            "Uptime"
          ];
        };
      };
    };
  };

  security.sudo.wheelNeedsPassword = false;

  systemd.user.services = {
    ircEmacsDaemon = makeEmacsDaemon { inherit config pkgs; name = "irc"; };
    editorEmacsDaemon = makeEmacsDaemon { inherit config pkgs; name = "scratchpad"; };
  };
}
