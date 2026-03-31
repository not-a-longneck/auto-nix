{ config, pkgs, ... }:

{
  home.username = "admin";
  home.homeDirectory = "/home/admin";
  home.stateVersion = "23.11"; # Match your initial install version

  # This is where your user-specific apps go now
  home.packages = with pkgs; [

    vlc
    tor-browser

  ];


  # VLC Config
  home.file.".config/vlc/vlcrc".text = ''
    [core]
    # Allow metadata = no
    metadata-network-access=0
    # Show hidden files = yes
    show-hiddenfiles=1
    # Playlist: display playlist tree = yes
    playlist-tree=1
    # Subdirectory behaviour = expand (0=default, 1=collapse, 2=expand)
    recursive=2
    # Play files randomly forever = yes
    random=1
    loop=1

    [qt]
    # Privacy popups = no
    qt-privacy-ask=0
    qt-notification=0
    # Resize video to interface = no
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



programs.plasma = {
    enable = true;
    # This modifies the existing "Task Manager" widget
    # instead of creating a brand new panel.
    configFile."plasmashellrc"."Favorite Apps"."value" = 
      "org.torproject.torbrowser.desktop,
      vlc.desktop,org.kde.dolphin.desktop,
      org.kde.konsole.desktop",
      pyload.desktop
    ;
  };

# This creates the Desktop icon
  home.file."Desktop/veracrypt.desktop".source = 
    "${pkgs.veracrypt}/share/applications/veracrypt.desktop";

  # Ensure the desktop is set to "Folder View" mode so you can see the icon
  programs.plasma = {
    enable = true;
    # Keep your taskbar favorites from before
    configFile."plasmashellrc"."Favorite Apps"."value" = 
      "systemsettings.desktop,org.kde.dolphin.desktop,org.torproject.torbrowser.desktop,vlc.desktop,veracrypt.desktop,pyload.desktop";
    
    # This ensures the desktop actually displays icons
    configFile."plasma-org.kde.plasma.desktop-appletsrc"."Serialization"]["Applets"]["20"]["Configuration"]["ConfigGroupDefault"]["plugin" = "org.kde.plasma.folderview";
  };


  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
