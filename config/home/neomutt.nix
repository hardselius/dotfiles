{
  enable = true;
  vimKeys = true;

  sidebar = {
    enable = true;
  };

  extraConfig = ''
    ## Default color definitions
    color attachment magenta default
    color bold brightblue default
    color hdrdefault red default
    color indicator brightwhite color234
    color markers yellow default
    color message white default
    color normal white default
    color quoted magenta default
    color search brightgreen default
    color signature blue default
    color status color240 color233
    color tilde brightyellow default
    color tree brightmagenta default
    color underline brightmagenta default
    color error red default

    # Colours for items in the index
    color index white default ~A
    color index default default ~R
    #color index magenta default ~O
    color index brightgreen default ~N
    color index brightmagenta default ~F
    color index brightred default ~T
    color index brightyellow default ~U
    color index red default ~D

    ## Highlights inside the body of a message.

    # URLs
    color body brightblue default "(http|ftp|news|telnet|finger)://[^ \"\t\r\n]*"
    color body brightblue default "mailto:[-a-z_0-9.]+@[-a-z_0-9.]+"

    # Email addresses.
    color body brightyellow default "[-a-z_0-9.%$]+@[-a-z_0-9.]+\\.[-a-z][-a-z]+"

    # Header
    color header blue default "^from:"
    color header magenta default "^to:"
    color header magenta default "^cc:"
    color header green default "^date:"
    color header yellow default "^newsgroups:"
    color header yellow default "^reply-to:"
    color header white default "^subject:"
    color header red default "^x-spam-rule:"
    color header green default "^x-mailer:"
    color header yellow default "^message-id:"
    color header yellow default "^Organization:"
    color header yellow default "^Organisation:"
    color header yellow default "^User-Agent:"
    color header yellow default "^message-id: .*pine"
    color header yellow default "^X-Fnord:"
    color header yellow default "^X-WebTV-Stationery:"
    color header red default "^x-spam-rule:"
    color header green default "^x-mailer:"
    color header yellow default "^message-id:"
    color header yellow default "^Organization:"
    color header yellow default "^Organisation:"
    color header yellow default "^User-Agent:"
    color header yellow default "^message-id: .*pine"
    color header yellow default "^X-Fnord:"
    color header yellow default "^X-WebTV-Stationery:"
    color header yellow default "^X-Message-Flag:"
    color header yellow default "^X-Spam-Status:"
    color header yellow default "^X-SpamProbe:"
    color header red default "^X-SpamProbe: SPAM"

    # Coloring quoted text - coloring the first 7 levels:
    color quoted1 yellow default
    color quoted2 blue default
    color quoted3 green default
    color quoted4 brightcyan default
    color quoted5 red default
    color quoted6 yellow default
    color quoted7 blue default
    color quoted8 green default
    color quoted9 brightcyan default
    # GPG Stuff
    # I can never get this fracking GPG regex's to work
    # Please fork and send a pull request
    #
    color body green default "gpg: Good signature"
    color body red default "gpg: BAD signature"
    color body red default "gpg: Can't check signature"

    ## Sidebar Patch
    color sidebar_new brightyellow default
  '';
}
