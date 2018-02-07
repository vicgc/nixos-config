{ config, pkgs, ... }:

let
  hostName = "${builtins.readFile ./.hostname}";

in {
  imports =
    [
      ./docker-gc.nix
      ./udiskie.nix
      ./hardware-configuration.nix
      ./packages.nix
      ./alacritty.nix
      ./autocutsel.nix
      ./docker-nginx-proxy.nix
    ];

  services.udisks2.enable = true;

  services.unclutter-xfixes.enable = true;

  services.emacs.enable = true;

  systemd.services.docker-nginx-proxy.enable = true;

  nixpkgs.config.zathura.useMupdf = true;

  boot.loader.timeout = 1;

  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 100000;
    "vm.swappiness" = 1;
    "vm.vfs_cache_pressure" = 50;
  };

  hardware = {
    bluetooth.enable = true;

    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
   };
  };

  time.timeZone = "Europe/Paris";

  i18n = {
    consoleKeyMap = "fr";
    defaultLocale = "en_US.UTF-8";
  };

  system = {
    stateVersion = "18.03";
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
  };

  nixpkgs.config.allowUnfree = true;

  programs.adb.enable = true;

  users.users.avo = {
    uid = 1000;
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "adbusers"
      "docker"
      "ipfs"
      "libvirtd"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "${builtins.readFile ./ssh-keys/avo.pub}"
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  environment.variables."EDITOR" = "vim";

  security.sudo.wheelNeedsPassword = false;

  services.offlineimap.enable = true;

  services.tor = {
    enable = true;
    torsocks.enable = true;
  };

  networking.hostName = hostName;

  environment.etc."/tsocks.conf".text = ''
    server = 127.0.0.1
    server_port = 19999
    server_type = 5
  '';

  services.avahi = {
    enable = true;
    publish.enable = true;
    nssmdns = true;
  };

  fonts.fontconfig.ultimate.enable = false;

  fonts.fonts = with pkgs; [
    corefonts
    google-fonts
    liberation_ttf
    vistafonts
  ];

  #networking.wireless.enable = true;

  networking.firewall.allowedTCPPorts = [
    80 443
    10000
    9999
    19000 19001
  ];

  services.xserver = {
    enable = true;
    layout = "fr";

    libinput = {
      enable = true;
      naturalScrolling = true;
      accelSpeed = "0.4";
    };

    displayManager = {
      auto = {
        enable = true;
        user = "avo";
      };
      sessionCommands = ''
        ${pkgs.sxhkd}/bin/sxhkd &
        ${pkgs.dropbox}/bin/dropbox start &
      '';
    };

    windowManager = {
      default = "xmonad";
      xmonad  = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
          haskellPackages.xmobar
        ];
      };
    };
  };

  programs.ssh.extraConfig = ''
    Host *
      ControlMaster auto
      ControlPersist 0
      ControlPath /tmp/ssh-%C
  '';

  virtualisation.docker.enable = true;

  systemd.services.docker-gc.enable = true;

  services.openvpn.servers = {
    us = { config = '' config /home/avo/.openvpn.conf ''; };
  };

  networking.enableIPv6 = false;

  services.ipfs.enable = true;
  environment.variables."IPFS_PATH" = "/var/lib/ipfs/.ipfs";

  virtualisation.libvirtd.enable = true;
  environment.variables."LIBVIRT_DEFAULT_URI" = "qemu:///system";

  services.dnsmasq = {
    enable = true;
    servers = ["8.8.8.8" "8.8.4.4"];

    extraConfig = ''
      address=/test/127.0.0.1
    '';
  };

  services.redshift = {
    enable = true;
    latitude = "48.85";
    longitude = "2.35";
    temperature.night = 2500;
  };

  services.printing = {
    enable = true;
    clientConf = ''
      <Printer default>
        UUID urn:uuid:3c151d9e-3d44-3a04-59f9-5cdfbb513438
        Info DCPL2520DW
        MakeModel everywhere
        DeviceURI ipp://192.168.1.15/ipp/print
      </Printer>
    '';
  };
}
