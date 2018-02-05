{ config, pkgs, ... }:

let
  docker-compose-completions = pkgs.callPackage ./packages/docker-compose-completions.nix {};
  docx2txt = pkgs.callPackage ./packages/docx2txt.nix {};
  libinput-gestures = pkgs.callPackage ./packages/libinput-gestures/default.nix {};
  miller = pkgs.callPackage ./packages/miller.nix {};

in {
  environment.systemPackages = with pkgs; [
    #bitcoin
    #csvtotable
    #uzbl
    #x_x
    (lowPrio moreutils) # prefer GNU parallel
    (lowPrio texlive.combined.scheme-full)
    acpi
    alacritty
    alsaPlugins
    alsaUtils
    androidsdk
    antiword
    aria
    asciinema
    awscli
    azure-cli
    binutils
    boot
    camingo-code
    chromium
    cups
    curl
    dateutils
    direnv
    dnsutils
    docker-machine
    docker_compose docker-compose-completions
    docx2txt
    dosfstools
    dropbox-cli
    dunst
    dunst
    emacs
    enscript
    exiv2
    expect
    ffcast
    ffmpeg
    file
    fira-code
    firefox-devedition-bin
    fzf
    gcc
    gcolor2
    geoipWithDatabase
    ghc
    ghostscript
    gist
    git
    gitAndTools.hub
    gnumake
    go-pup
    go_1_6
    google-cloud-sdk
    google-drive-ocamlfuse
    gradle
    graphicsmagick
    graphviz
    hack-font
    haskellPackages.xmobar
    highlight
    html2text
    httpie
    httping
    iftop
    imagemagick
    inkscape
    inotify-tools
    iotop
    jdk
    jo
    jq
    lastpass-cli
    leiningen
    libinput-gestures
    libnotify
    libreoffice-fresh
    libxls
    linuxPackages.perf
    lsof
    mailutils
    maim
    mariadb
    mediainfo
    megatools
    miller
    mongodb
    mongodb-tools
    mpv
    msmtp
    mupdf
    mutt
    neomutt
    netcat
    nethogs
    netpbm
    ngrep
    nix-prefetch-scripts
    nix-zsh-completions
    nixops
    nmap
    nodejs-8_x
    notmuch
    notmuch-addrlookup
    notmuch-mutt
    ntfs3g
    ocrad
    offlineimap
    openssl
    pandoc
    parallel perlPackages.DBDSQLite
    pdfgrep
    pdftk
    perlPackages.HTMLParser
    pgcli
    pianobar
    ponymix
    poppler_utils
    postgresql
    profont
    psmisc
    pv
    python
    python27Packages.setuptools
    python35Packages.pygments
    recode
    redis
    redshift
    remarshal
    ripgrep
    rlwrap
    rofi
    rsync
    ruby
    rxvt_unicode-with-plugins
    scrot
    setroot
    slop
    socat
    sqlite
    sshuttle
    st
    stack
    strace
    sxhkd
    sxiv
    t
    tcpdump
    tdesktop
    telnet
    tesseract
    tmate
    tmux
    torbrowser
    torsocks
    traceroute
    tree
    tsocks
    ttyrec
    units
    unoconv
    unzip
    urlview
    usbutils
    vaapiVdpau
    vimHugeX
    virt-viewer
    w3m
    watchman
    wdiff
    weechat
    wget
    whois
    wmctrl
    xbindkeys
    xclip
    xdg_utils
    xdotool
    xfce.thunar
    xlsx2csv
    xmind
    xml2
    xorg.xev
    xorg.xinput
    xorg.xrandr
    xorg.xset
    xsel
    xurls
    yarn
    youtube-dl
    zathura
    zip
  ];
}
