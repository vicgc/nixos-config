{ pkgs, myName, myEmail, lib, ... }:

let
  myName = "Andrei Vladescu-Olt"; myEmail = "andrei@avolt.net";

in {
  environment.systemPackages = (with pkgs; [
    isync # https:++wiki.archlinux.org/index.php/Isync https:++gist.github.com/au/a271c09e8233f19ffb01da7f017c7269 https:++github.com/kzar/davemail
    mailutils
    msmtp
    notmuch
    procmail
  ]);

  home-manager.users.avo.xdg.configFile = {
    "offlineimap/config".text = lib.generators.toINI {} {
      general = {
        accounts = "avolt.net";
        fsync = false;
        maxconnections = 10;
        autorefresh = "0.5";
        quick = 10;
      };

      "Account avolt.net" = {
        localrepository = "avolt.net_local";
        postsynchook = "${pkgs.notmuch}/bin/notmuch new";
        realdelete = "yes";
        remoterepository = "avolt.net_remote";
      };

      "Repository avolt.net_local" = {
        localfolders = "~/mail/avolt.net";
        type = "Maildir";
        nametrans = "lambda folder: folder == 'INBOX' and 'INBOX' or ('INBOX.' + folder)";
      };

      "Repository avolt.net_remote" = {
        type = "Gmail";
        nametrans = "lambda folder: {'[Gmail]/All Mail': 'archive',}.get(folder, folder)";
        folderfilter = "lambda folder: folder == '[Gmail]/All Mail'";
        realdelete = "yes";
        remoteuser = "andrei@avolt.net";
        remotepass = builtins.getEnv "AVOLT_GOOGLE_PASSWORD";
        sslcacertfile = "/etc/ssl/certs/ca-certificates.crt";
        synclabels = "yes";
        keepalive = 60;
        holdconnectionopen = "yes";
      };
    };
  };

  home-manager.users.avo.home.file = {
    ".mailcap".text = ''
      application/doc; plaintextify < %s; copiousoutput
      application/msword; plaintextify < %s; copiousoutput
      application/pdf; zathura %s pdf
      application/vnd.ms-powerpoint; libreoffice %s
      application/vnd.ms-powerpoint; ppt2txt '%s'; copiousoutput; description=MS PowerPoint presentation;
      application/vnd.openxmlformats-officedocument.presentationml.presentation; libreoffice %s
      application/vnd.openxmlformats-officedocument.presentationml.presentation; plaintextifypptx2txt < %s; copiousoutput
      application/vnd.openxmlformats-officedocument.presentationml.slideshow; libreoffice %s
      application/vnd.openxmlformats-officedocument.presentationml.slideshow; plaintextify < %s
      application/vnd.openxmlformats-officedocument.spreadsheetmleet; plaintextify < %s xls
      application/vnd.openxmlformats-officedocument.wordprocessingml.document; plaintextify < %s; copiousoutput
      image; sxiv %s
      text/html; qutebrowser-open;
      text/html; w3m -o display_link=true -o display_link_number=true -dump -I %{charset} -cols 72 -T text/html %s; nametemplate=%s.html; copiousoutput
      text/plain; view-attachment %s txt
    '';

    ".mailrc".text = ''
      set sendmail=${pkgs.msmtp}/bin/msmtp"
    '';

    ".notmuch-config".text = lib.generators.toINI {} {
      user = {
        name = myName;
        primary_email = myEmail;
        other_email = "andrei.volt@gmail.com";
      };

      new = {
        tags = "unread;inbox;";
        ignore = "";
      };

      search = {
        exclude_tags = "deleted;spam;";
      };

      maildir = {
        synchronize_flags = true;
      };
    };
  };
}