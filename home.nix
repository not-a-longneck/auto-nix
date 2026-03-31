{ config, pkgs, ... }:

{
  home.username = "admin";
  home.homeDirectory = "/home/admin";
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    vlc
    tor-browser
    veracrypt # Added here to ensure the desktop shortcut finds the icon
  ];

###################################
#### PROGRAM SPECIFIC SETTINGS ####
###################################

  # VLC Config
  home.file.".config/vlc/vlcrc".text = ''
    [core]
    metadata-network-access=0
    show-hiddenfiles=1
    playlist-tree=1
    recursive=2
    random=1
    loop=1
    [qt]
    qt-privacy-ask=0
    qt-notification=0
    qt-video-autoresize=0
  '';

  # Tor browser
  home.file.".tor project/TorBrowser/Data/Browser/profile.default/user.js".text = ''
    user_pref("javascript.enabled", false);
    user_pref("extensions.torlauncher.prompt_at_startup", false);
    user_pref("network.bootstrapped", true);
    user_pref("intl.accept_languages", "en-US, en");
    user_pref("intl.locale.requested", "en-US");
    user_pref("browser.toolbars.bookmarks.visibility", "never");
  '';

###################################
#### PLASMA  SPECIFIC SETTINGS ####
###################################


  # Create Desktop Shortcut
  home.file."Desktop/veracrypt.desktop".source = 
    "${pkgs.veracrypt}/share/applications/veracrypt.desktop";

  programs.plasma = {
    enable = true;

    # Taskbar Favorites
    configFile."plasmashellrc"."Favorite Apps"."value" = "systemsettings.desktop,org.kde.dolphin.desktop,org.torproject.torbrowser.desktop,vlc.desktop,veracrypt.desktop,pyload.desktop";
    
    # Desktop Icons (Folder View)
    # This version uses the "attribute set" style which is much safer for Nix
    configFile."plasma-org.kde.plasma.desktop-appletsrc" = {
      "Serialization"."Applets"."20"."Configuration"."ConfigGroupDefault"."plugin" = "org.kde.plasma.folderview";
    };
  };

  programs.home-manager.enable = true;
}
